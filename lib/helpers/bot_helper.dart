import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/botchat.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/message.dart';
import '../models/draft.dart' show Draft;
import 'package:me_flutting/models/mbody.dart';
import 'package:http/http.dart' as http;
import 'sql_helper.dart' as sql;

class BotCommand {
  final String cmd;
  final String description;
  final int argNum;
  final Future<MBody> Function([List<RawBody> args]) func;

  const BotCommand(
      {this.cmd = 'help', this.description, this.argNum, this.func});

  @override
  bool operator ==(Object other) {
    return other is String && other.trim() == cmd.trim();
  }

  @override
  int get hashCode => cmd.hashCode;

  @override
  String toString() {
    return '[Command] $cmd = $description';
  }
}

class BotManager extends BotChat {
  final List<BotCommand> commands;
  BotManager(this.commands, BotChat botObj)
      : super(botObj.id, botObj.owner, botObj.username);

  Future<Message> msgMiddleMan(Draft draft) async {
    final msg = await messageTable.insertMessage(draft);
    final botResponse = await executeCmd(msg.body);
    if (botResponse.toString().length <= Message.CHARACTER_LIMIT) {
      final newBotMsg = msg.chatGroup.createMessage(msg.chatGroup, botResponse);
      await messageTable.insertMessage(newBotMsg);
    } else {
      await messageTable.insertMessage(msg.chatGroup.createMessage(
          msg.chatGroup, RawBody('''message was too large to show!
          (character limit: ${Message.CHARACTER_LIMIT}) ''')));
    }
    return msg;
  }

  Future<MBody> executeCmd(RawBody cmdText) async {
    final cmdStr = cmdText.toString();
    for (final _ in commands) {
      if (cmdStr.startsWith(_.cmd)) {
        final start = _.cmd.length + 1;
        if (cmdStr.length <= start)
          return RawBody('ERROR: no arguments supplied!');
        final _args = cmdStr.substring(start).split(';');
        if (_args.length != _.argNum)
          return RawBody('ERROR: number of arguments doesn\'t match!');
        return _.func(_args.map((s) => RawBody(s)).toList());
      }
    }
    return RawBody('available commands:\n ${commands.join('\n')}');
  }

  static Map<String, BotManager> memoizer = Map();
  static BotManager findManagerByBot(BotChat bc) {
    final _key = bc.username;
    return memoizer.putIfAbsent(_key, () => BotManager(cmdList[_key], bc));
  }

  static Map<String, List<BotCommand>> cmdList = {
    'sql': [
      BotCommand(
          cmd: 'open',
          description: 'opens the database specified. \n arg[0]: database name',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              final db = await sql.open(na);
              return RawBody('database $na status : ${db.isOpen}');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'select',
          description: 'lets you run raw queries. \n arg[0]: query text',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              final result = await sql.queryRaw(na);
              return RawBody(result);
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'insert',
          description:
              'lets you execute raw insert commands. \n arg[0]: command text',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              await sql.insertRaw(na);
              return RawBody('OK!');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'update',
          description:
              'lets you execute raw update commands. \n arg[0]: command text',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              await sql.updateRaw(na);
              return RawBody('OK!');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'delete',
          description:
              'lets you execute raw delete commands. \n arg[0]: command text',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              await sql.deleteRaw(na);
              return RawBody('OK!');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
    ],

// --------------------
    'api': [
      BotCommand(
          cmd: 'get',
          description: 'get request for an URL.',
          argNum: 1,
          func: ([args]) async {
            try {
              // https://jsonplaceholder.typicode.com/albums/1
              final uri = Uri.parse(args[0].toString());
              final response = await http.get(uri);
              if (response.statusCode == 200)
                return RawBody('${response.body}');
              else
                return RawBody('invalid url');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
    ],
    'efendi': []
  };
}

// // //
