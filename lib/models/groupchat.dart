import 'chat.dart' show Chat, ChatTypes;

class GroupChat extends Chat {
  final int maximumParticipants;
  GroupChat(name,
      [String photoURL = 'group_avatar.png', this.maximumParticipants = 10])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => name;

  @override
  ChatTypes get type => ChatTypes.Group;
}
