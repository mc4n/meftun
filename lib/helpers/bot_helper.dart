import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/botchat.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/models/mbody.dart';
import 'table_helper.dart';

class BotCommand {
  final String cmd;
  final String description;
  final int argNum;
  final Future<String> Function([List<String> args]) func;

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
  List<BotCommand> _builtInCommands;
  final List<BotCommand> commands;
  BotManager(this.commands, BotChat botObj)
      : super(botObj.id, botObj.owner, botObj.username) {
    _builtInCommands = [
      BotCommand(
          cmd: 'help',
          argNum: 0,
          description: 'lists all the available commands.',
          func: ([_]) async => 'available commands:\n ${commands.join('\n')}'),
    ];
  }

  Future<void> msgMiddleMan(Message msg) async {
    await myContext.tableEntityOf<MessageTable>().insertMessage(msg);
    final response = await executeCmd(msg.body.toString());
    final newMsg =
        msg.chatGroup.createMessage(msg.chatGroup, RawBody(response));
    await myContext.tableEntityOf<MessageTable>().insertMessage(newMsg);
  }

  Future<String> executeCmd(String cmdText, [List<String> args]) async {
    for (final _ in _builtInCommands) if (_.cmd == cmdText) return _.func(args);
    for (final c in commands) if (c.cmd == cmdText) return c.func(args);
    return "invalid command!";
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
        func: ([args]) async => 'selecting...',
      ),
    ],
    'api': [
      BotCommand(
        cmd: 'get',
        description: 'get request for an URL.',
        argNum: 1,
        func: ([args]) async => 'requesting...',
      ),
    ],
    'efendi': []
  };
}

// // //
