import 'directchat.dart' show DirectChat;

class BotChat extends DirectChat {
  final DirectChat owner;
  BotChat(String id, this.owner, String displayName,
      {String defaultPhotoURL = 'bot_avatar.png'})
      : super(id, displayName, defaultPhotoURL: defaultPhotoURL);

  @override
  String get caption => '$displayName[Bot]';

  @override
  String get type => 'B';
}
