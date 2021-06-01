import 'chat.dart' show Chat;

class GroupChat extends Chat {
  GroupChat(name, [String photoURL = 'group_avatar.png'])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => name;
}
