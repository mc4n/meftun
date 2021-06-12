import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/botchat.dart';
import 'package:me_flutting/main.dart';

class BotCommand {
  final String cmd;
  final String description;
  final Future<String> Function([List<String> args]) func;

  const BotCommand({this.cmd = 'help', this.description, this.func});

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
          description: 'lists all the available commands.',
          func: ([_]) async => commands.join('\n')),
    ];
  }

  Future<String> executeCmd(String cmdText, [List<String> args]) async {
    for (final _ in _builtInCommands) if (_ == cmdText) return _.func(args);
    for (final c in commands) if (c == cmdText) return c.func(args);
    return "invalid command!";
  }
}

// // //

BotManager get sqlCli {
  final cmdList = <BotCommand>[
    BotCommand(
      cmd: 'select',
      description: 'selects rows from the table specified.',
      func: ([args]) async => 'selecting...',
    ),
  ];
  final sqlCli =
      BotManager(cmdList, BotChat('powkdpowkdqw', meSession, 'sql_bot'));
  return sqlCli;
}

void main() {
  test('test bot commands', () async {
    final response1 = await sqlCli.executeCmd('help');
    final response2 = await sqlCli.executeCmd('select');
    expect(response1, isNotNull);
    expect(response2, isNotNull);
  });
}
