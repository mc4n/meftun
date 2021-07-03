import 'chat.dart' show Chat;

class GroupChat extends Chat {
  final int maximumParticipants;
  GroupChat(String id, String username,
      {String name,
      String photoURL = 'group_avatar.png',
      this.maximumParticipants = 10})
      : super(id, username, photoURL);

  @override
  String get caption => displayName;

  @override
  String get type => Chat.GROUP;
}
