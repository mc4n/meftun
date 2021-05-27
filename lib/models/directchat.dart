import 'package:me_flutting/models/chat.dart';

class DirectChat extends Chat {
  final String username;

  DirectChat(this.username, [name = '']) : super(Chat.uuid.v4(), name);

  @override
  String get caption => username;
}
