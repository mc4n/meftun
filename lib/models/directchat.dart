import 'groupchat.dart' show GroupChat;
import 'chat.dart' show ChatTypes;

class DirectChat extends GroupChat {
  final String username;

  DirectChat(this.username, [String name, String photoURL = 'avatar.png'])
      : super(name, photoURL, 2);

  @override
  String get caption => username;

  @override
  ChatTypes get type => ChatTypes.Direct;
}
