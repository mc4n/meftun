import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/directchat.dart' show DirectChat;
import 'package:me_flutting/types/groupchat.dart' show GroupChat;
import 'package:me_flutting/types/botchat.dart' show BotChat;
import 'basemodel.dart';

class ChatModel implements ModelBase {
  final String id;
  final String userName;
  final String name;
  final String photoURL;
  final String type;
  const ChatModel(this.id, this.userName, this.name, this.photoURL, this.type);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'user_name': userName,
        'name': name,
        'photo_url': photoURL,
        '_type': type,
      };

  Chat get asChat {
    switch (type) {
      case Chat.BOT:
        return BotChat(id, null, userName, name: name, photoURL: photoURL);
      case Chat.DIRECT:
        return DirectChat(id, userName, name: name, photoURL: photoURL);
      case Chat.GROUP:
      default:
        return GroupChat(id, userName, name: name, photoURL: photoURL);
    }
  }
}
