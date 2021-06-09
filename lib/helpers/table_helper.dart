import '../models/chat.dart' show Chat, ChatTypes;
import '../models/directchat.dart' show DirectChat;
import '../models/groupchat.dart' show GroupChat;
import '../models/message.dart' show Message;
//import '../models/mbody.dart' show MBody, RawBody;
import 'sql_helper.dart';

class ChatTable extends TableEntity<ChatModel> {
  ChatTable()
      : super(
            'tb_chats',
            'id nvarchar(200) primary key not null,'
                'user_name nvarchar(15) not null,'
                'name nvarchar(50) not null,'
                'photo_url nvarchar(200) not null,'
                'type integer not null');

  @override
  ChatModel from(Map<String, dynamic> _map) {
    return ChatModel(
      _map['id'],
      _map['user_name'],
      _map['name'],
      _map['photo_url'],
      _map['type'],
    );
  }

  Future<void> insertChat(Chat item) async {
    super.insert(ChatModel(item.id, item.caption, item.name, item.photoURL, 0));
  }
}

class ChatModel with ModelBase {
  final String id;
  final String userName;
  final String name;
  final String photoURL;
  final int type;
  const ChatModel(this.id, this.userName, this.name, this.photoURL, this.type);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'user_name': userName,
        'name': name,
        'photo_url': photoURL,
        'type': type,
      };

  Chat toChat() {
    switch (ChatTypes.Direct) {
      case ChatTypes.Direct:
        return DirectChat(id, userName, name, photoURL);
      case ChatTypes.Group:
        return GroupChat(id, name, photoURL);
      default:
        return null;
    }
  }
}

// /// ////

class MessageTable extends TableEntity<MessageModel> {
  MessageTable()
      : super(
            'tb_messages',
            'id nvarchar(200) primary key not null,'
                'body nvarchar(900) not null,'
                'from_id nvarchar(200) not null,'
                'chat_group_id nvarchar(200) not null,'
                'epoch integer not null');

  @override
  MessageModel from(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
    );
  }

  Future<void> insertMessage(Message item) async {
    super.insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch));
  }
}

class MessageModel with ModelBase {
  final String id;
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  const MessageModel(
      this.id, this.body, this.fromId, this.chatGroupId, this.epoch);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
      };
}
