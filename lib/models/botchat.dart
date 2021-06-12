import 'directchat.dart' show DirectChat;

class BotChat extends DirectChat {
  final DirectChat owner;
  BotChat(String id, this.owner, String username,
      {String name, String photoURL = 'bot_avatar.png'})
      : super(id, username, name: name, photoURL: photoURL);

  @override
  String get caption => '$username[Bot]';

  @override
  String get type => 'B';
}
