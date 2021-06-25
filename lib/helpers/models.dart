import '../types/chat.dart' show Chat;
import '../types/directchat.dart' show DirectChat;
import '../types/groupchat.dart' show GroupChat;
import '../types/botchat.dart' show BotChat;
import '../types/mbody.dart' show MBody, RawBody, ImageBody;

abstract class ModelBase {
  String get getId;
  Map<String, dynamic> get map;
}

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

class MessageModel implements ModelBase {
  final String id;
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  final String mbodyType;
  const MessageModel(this.id, this.body, this.fromId, this.chatGroupId,
      this.epoch, this.mbodyType);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
        'mbody_type': mbodyType,
      };

  static int compareEpoch(MessageModel _d1, MessageModel _d2) {
    var ep1 = _d1.epoch;
    var ep2 = _d2.epoch;
    if (ep1 > ep2)
      return 1;
    else if (ep2 > ep1) return -1;
    return 0;
  }

  MBody get bodyObj {
    switch (mbodyType) {
      case MBody.IMAGE_MESSAGE:
        return ImageBody(body);
      case MBody.FILE_MESSAGE:
      case MBody.JSON_MESSAGE:
      case MBody.RAW_MESSAGE:
      default:
        return RawBody(body);
    }
  }
}
