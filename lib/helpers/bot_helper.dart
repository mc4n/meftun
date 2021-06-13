import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/botchat.dart';
import 'package:me_flutting/main.dart';
import 'package:me_flutting/models/message.dart';
import '../models/draft.dart' show Draft;
import 'package:me_flutting/models/mbody.dart';
import 'table_helper.dart';

class BotCommand {
  final String cmd;
  final String description;
  final int argNum;
  final Future<MBody> Function([List<MBody> args]) func;

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
          func: ([_]) async =>
              RawBody('available commands:\n ${commands.join('\n')}')),
    ];
  }

  Future<Message> msgMiddleMan(Draft msg) async {
    final item =
        await myContext.tableEntityOf<MessageTable>().insertMessage(msg);
    final botResponse = await executeCmd(msg.body);
    final newBotMsg = msg.chatGroup.createMessage(msg.chatGroup, botResponse);
    await myContext.tableEntityOf<MessageTable>().insertMessage(newBotMsg);
    return item;
  }

  Future<MBody> executeCmd(MBody cmdText, [List<MBody> args]) async {
    for (final _ in _builtInCommands)
      if (_.cmd == cmdText.toString()) return _.func(args);
    for (final c in commands)
      if (c.cmd == cmdText.toString()) return c.func(args);
    return RawBody('invalid command!');
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
        func: ([args]) async => RawBody('requesting...'),
      ),
    ],
    'efendi': []
  };
}

// // //
