import 'package:me_flutting/models/chat.dart';

class DirectChat extends Chat {
  final String username;

  DirectChat(this.username, [name = '', photoURL = ''])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => username;
}
