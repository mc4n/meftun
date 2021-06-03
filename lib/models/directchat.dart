import 'groupchat.dart' show GroupChat;

class DirectChat extends GroupChat {
  final String username;

  DirectChat(this.username, [String name, String photoURL = 'avatar.png'])
      : super(name, photoURL, 2);

  @override
  String get caption => username;
}
