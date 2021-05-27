import 'package:me_flutting/models/chat.dart';

class DirectChat extends Chat {
  final String username;

  DirectChat(this.username, [name = '', photoURL = ''])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => username;
}

final DirectChat me = DirectChat("mcan", "Mustafa Can");
const ITEM_C = 5;
final List<DirectChat> contacts = [
  DirectChat('2pac'),
  DirectChat('ali'),
  DirectChat('veli'),
  DirectChat('deli'),
  DirectChat('peri')
];
