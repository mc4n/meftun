import 'groupchat.dart' show GroupChat;

class DirectChat extends GroupChat {
  DirectChat(String id, String username,
      {String name, String photoURL = 'avatar.png'})
      : super(id, username,
            name: name, photoURL: photoURL, maximumParticipants: 2);

  @override
  String get type => 'D';
}
