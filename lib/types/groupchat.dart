import 'chat.dart' show Chat;

class GroupChat extends Chat {
  final int maximumParticipants;
  GroupChat(String id, String displayName,
      {String defaultPhotoURL = 'group_avatar.png',
      this.maximumParticipants = 10})
      : super(id, displayName, defaultPhotoURL);

  @override
  String get caption => displayName;

  @override
  String get type => Chat.GROUP;
}
