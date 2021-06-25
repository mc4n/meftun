import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:me_flutting/types/botchat.dart';
import 'package:me_flutting/types/message.dart';
import 'package:me_flutting/types/draft.dart' show Draft;
import 'package:me_flutting/types/mbody.dart';
import 'sql_context.dart' show SqlDbaseContext;
import 'tables.dart' show ChatTable, MessageTable;

void fillDefaultBots(ChatTable chatTable) {
  final botEfendi = BotChat('5', null, 'efendi', name: 'Bot Efendi');
  chatTable.insertChat(botEfendi);
  chatTable.insertChat(BotChat('6', botEfendi, 'api', name: 'API helper bot'));
  chatTable
      .insertChat(BotChat('7', botEfendi, 'sql', name: 'SQLite helper bot'));
}

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
  final MessageTable messageTable;
  static SqlDbaseContext sql = SqlDbaseContext.instance();
  BotManager(this.commands, BotChat botObj, this.messageTable)
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
  static BotManager findManagerByBot(BotChat bc, MessageTable msgTable) {
    final _key = bc.username;
    return memoizer.putIfAbsent(
        _key, () => BotManager(cmdList[_key], bc, msgTable));
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
          description: 'get data from a URL.',
          argNum: 1,
          func: ([args]) async {
            try {
              // get https://reqres.in/api/users?delay=3
              final uri = Uri.parse(args[0].toString());
              final response = await http.get(uri);
              return RawBody('${response.body}');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
      BotCommand(
          cmd: 'post',
          description: 'post data to a URL.',
          argNum: 2,
          func: ([args]) async {
            try {
              // post https://reqres.in/api/users;{"name": "ali", "job": "doctor"}
              final response = await http.post(Uri.parse(args[0].toString()),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: args[1].toString());
              return RawBody('${response.body}');
            } catch (_) {
              return RawBody(_.message);
            }
          }),
    ],
    'efendi': []
  };
}
