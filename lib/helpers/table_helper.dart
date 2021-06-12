import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../models/groupchat.dart' show GroupChat;
import '../models/botchat.dart' show BotChat;
import '../models/message.dart' show Message;
import '../models/mbody.dart' show MBody, RawBody, ImageBody;
import 'sql_helper.dart';

class ChatTable extends TableEntity<ChatModel> {
  ChatTable() : super('tb_chats');

  @override
  ChatModel from(Map<String, dynamic> _map) {
    return ChatModel(
      _map['id'],
      _map['user_name'],
      _map['name'],
      _map['photo_url'],
      _map['_type'],
    );
  }

  Future<void> insertChat(Chat item) async {
    super.insert(
        ChatModel(item.id, item.username, item.name, item.photoURL, item.type));
  }
}

class ChatModel with ModelBase {
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

  Chat toChat() {
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

// /// ////

class MessageTable extends TableEntity<MessageModel> {
  MessageTable() : super('tb_messages');

  @override
  MessageModel from(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
      _map['mbody_type'],
    );
  }

  Future<void> insertMessage(Message item) async {
    super.insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
  }

  Future<Message> getMessageDetails(
      bool Function(MessageModel) predicate) async {
    final chatSource = context.tableEntityOf<ChatTable>();
    final msgModel = await super.single(predicate);
    final from = await chatSource.single((m) => m.id == msgModel.fromId);
    final to = await chatSource.single((m) => m.id == msgModel.chatGroupId);
    final bodyObj = (String bt, String mb) {
      switch (bt) {
        case MBody.IMAGE_MESSAGE:
          return ImageBody(mb);
        case MBody.FILE_MESSAGE:
        case MBody.JSON_MESSAGE:
        case MBody.RAW_MESSAGE:
        default:
          return RawBody(mb);
      }
    };
    return Message(msgModel.id, bodyObj(msgModel.mbodyType, msgModel.body),
        from.toChat(), to.toChat(), msgModel.epoch);
  }

  @override
  Future<List<MessageModel>> select() async {
    final ls = await super.select();
    ls.sort(MessageModel.compareEpoch);
    return ls;
  }
}

class MessageModel with ModelBase {
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
}
