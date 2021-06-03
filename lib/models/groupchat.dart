import 'chat.dart' show Chat;

class GroupChat extends Chat {
  final int maximumParticipants;
  GroupChat(name,
      [String photoURL = 'group_avatar.png', this.maximumParticipants = 10])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => name;
}
