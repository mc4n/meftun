import 'chat.dart' show Chat;

class GroupChat extends Chat {
  final int maximumParticipants;
  GroupChat(String id, String username,
      {String name,
      String photoURL = 'group_avatar.png',
      this.maximumParticipants = 10})
      : super(id, username, name, photoURL);

  @override
  String get caption => username;

  @override
  String get type => Chat.GROUP;
}
