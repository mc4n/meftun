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
        if (_.argNum > 0) {
          final start = _.cmd.length + 1;
          if (cmdStr.length <= start)
            return RawBody('ERROR: no arguments supplied!');
          final _args = cmdStr.substring(start).split(';');
          if (_args.length != _.argNum)
            return RawBody('ERROR: number of arguments doesn\'t match!');
          return _.func(_args.map((s) => RawBody(s)).toList());
        } else
          return _.func();
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
          cmd: 'select',
          description: '<String> queryRaw(String queryText)',
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
          description: '<int> insertRaw(String cmdText)',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              return RawBody('OK! ${await sql.insertRaw(na)} rows effected.');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'update',
          description: '<int> updateRaw(String cmdText)',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              return RawBody('OK! ${await sql.updateRaw(na)} rows effected.');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'delete',
          description: '<int> deleteRaw(String cmdText)',
          argNum: 1,
          func: ([args]) async {
            try {
              final na = args[0].toString();
              return RawBody('OK! ${await sql.deleteRaw(na)} rows effected.');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'all',
          description: 'Future<String> queryAllAsText(String table)',
          argNum: 1,
          func: ([args]) async {
            try {
              return RawBody(await sql.queryAllAsText(args[0].toString()));
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'list',
          description:
              'Future<String> queryAsText(String table, int limit, int offset)',
          argNum: 3,
          func: ([args]) async {
            try {
              return RawBody(await sql.queryAsText(
                  args[0].toString(),
                  int.parse(args[1].toString()),
                  int.parse(args[2].toString())));
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'where',
          description:
              '<String> queryWhereAsText(String table, String where, List<String> whereArgs, int limit, int offset)',
          argNum: 5,
          func: ([args]) async {
            try {
              return RawBody(await sql.queryWhereAsText(
                  args[0].toString(),
                  args[1].toString(),
                  args[2].toString().split(','),
                  int.parse(args[3].toString()),
                  int.parse(args[4].toString())));
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'execute',
          description: '<void> execute(String queryText)',
          argNum: 1,
          func: ([args]) async {
            try {
              await sql.execute(args[0].toString());
              return RawBody('OK!');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'del',
          description:
              '<int> deleteAsText(String table, String where, List<String> whereArgs)',
          argNum: 3,
          func: ([args]) async {
            try {
              return RawBody((await sql.deleteAsText(args[0].toString(),
                      args[1].toString(), args[2].toString().split(',')))
                  .toString());
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
