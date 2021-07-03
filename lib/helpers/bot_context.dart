import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/types/botchat.dart';
import 'package:me_flutting/types/message.dart';
import 'package:me_flutting/types/draft.dart' show Draft;
import 'package:me_flutting/types/mbody.dart';
import 'package:me_flutting/tables/chattable.dart' show ChatTable;
import 'package:me_flutting/tables/messagetable.dart' show MessageTable;

void fillDefaultBots(ChatTable chatTable) async {
  await chatTable.delete('0');
  chatTable.insertChat(BotChat('0', null, 'efendi', name: 'Bot Efendi'));
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
  BotManager(this.commands, BotChat botObj, this.messageTable)
      : super(botObj.id, botObj.owner, botObj.displayName);

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
    final _key = bc.id;
    return memoizer.putIfAbsent(
        _key, () => BotManager(cmdList[_key], bc, msgTable));
  }

  static Map<String, List<BotCommand>> cmdList = {
    '0': [
      BotCommand(
          cmd: 'config',
          description: 'set a configuration.',
          argNum: 2,
          func: ([args]) async {
            try {
              return throw Exception();
            } catch (_) {
              return RawBody(_.message);
            }
          }),
    ],
  };
}
