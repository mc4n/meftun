import 'groupchat.dart' show GroupChat;

class DirectChat extends GroupChat {
  final String username;

  DirectChat(String id, this.username,
      [String name, String photoURL = 'avatar.png'])
      : super(id, name, photoURL, 2);

  @override
  String get caption => username;
}
