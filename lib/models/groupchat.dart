import 'chat.dart';

class GroupChat extends Chat {
  GroupChat(name]) : super(Chat.uuid.v4(), name);

  @override
  String get caption => name;
}
