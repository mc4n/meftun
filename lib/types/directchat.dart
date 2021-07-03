import 'groupchat.dart' show GroupChat;

class DirectChat extends GroupChat {
  DirectChat(String id, String displayName,
      {String defaultPhotoURL = 'avatar.png'})
      : super(id, displayName,
            defaultPhotoURL: defaultPhotoURL, maximumParticipants: 2);

  @override
  String get type => 'D';
}
