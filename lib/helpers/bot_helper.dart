import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/botchat.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/message.dart';
import '../models/draft.dart' show Draft;
import 'package:me_flutting/models/mbody.dart';
import 'table_helper.dart';
import 'package:http/http.dart' as http;

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
    final msg =
        await myContext.tableEntityOf<MessageTable>().insertMessage(draft);
    final botResponse = await executeCmd(msg.body);
    final newBotMsg = msg.chatGroup.createMessage(msg.chatGroup, botResponse);
    await myContext.tableEntityOf<MessageTable>().insertMessage(newBotMsg);
    return msg;
  }

  Future<MBody> executeCmd(RawBody cmdText) async {
    final cmdStr = cmdText.toString();
    for (final _ in commands) {
      if (cmdStr.startsWith(_.cmd)) {
        final start = _.cmd.length + 1;
        if (cmdStr.length <= start) return RawBody('request not long enough.');
        final _args = cmdStr.substring(start).split(' ');
        if (_args.length != _.argNum)
          return RawBody('wrong number of arguments supplied!');
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
        cmd: 'select',
        description: 'selects rows from the table specified.',
        argNum: 1,
        func: ([args]) async => RawBody('selecting...'),
      ),
    ],
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
                return RawBody(
                    'uri:$uri \n\n\n\nResponse header:\n${response.headers}\n\n\nResponse body:\n${response.body}');
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
