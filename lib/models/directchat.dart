import 'chat.dart' show Chat;

class DirectChat extends Chat {
  final String username;

  DirectChat(this.username, [String name = '', String photoURL = 'avatar.png'])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => username;
}
