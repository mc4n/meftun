import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../models/groupchat.dart' show GroupChat;
import '../models/botchat.dart' show BotChat;
import '../models/message.dart' show Message;
import '../models/draft.dart' show Draft;
import '../models/mbody.dart' show MBody, RawBody, ImageBody;
import 'sql_helper.dart' as sql;

abstract class TableEntity<T extends sql.ModelBase> {
  static const PAGE_LEN = 25;
  final String tableName;
  TableEntity(this.tableName);

  T from(Map<String, dynamic> _map);

  Future<List<T>> select([int pageNum = 0]) async =>
      (await sql.query(tableName, PAGE_LEN, pageNum * PAGE_LEN, from)).toList();

  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
          [int pageNum = 0]) async =>
      (await sql.queryWhere(
              tableName, _where, whereArgs, PAGE_LEN, pageNum * PAGE_LEN, from))
          .toList();

  Future<List<T>> selectByOne(String field, dynamic value,
          [int pageNum = 0]) async =>
      (await sql.queryWhere(tableName, '$field = ?', [value], PAGE_LEN,
              pageNum * PAGE_LEN, from))
          .toList();

  Future<T> single(String _where, List<dynamic> whereArgs) async {
    final res =
        (await sql.queryWhere(tableName, _where, whereArgs, 1, 0, from));
    return res != null && res.length == 1 ? res.first : null;
  }

  Future<bool> insert(T item) async => (await sql.insert(tableName, item)) > 0;

  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async =>
      (await sql.delete(tableName, _where, whereArgs)) > 0;

  Future<bool> deleteByOne(String field, dynamic value) async =>
      deleteWhere('$field = ?', value);

  Future<bool> delete(String id) async => deleteByOne('id', id);
}

//-------

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

  Future<bool> insertChat(Chat item) async => super.insert(
      ChatModel(item.id, item.username, item.name, item.photoURL, item.type));

  Future<Chat> getChat(String id) async =>
      (await super.single('id = ?', [id])).asChat;

  Future<List<Chat>> chats() async =>
      (await super.select()).map((cm) => cm.asChat).toList();
}

class ChatModel with sql.ModelBase {
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

  Future<Message> insertMessage(Draft dr) async {
    final item = dr is Message ? dr : dr.toMessage();
    insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
    return item;
  }

  Future<bool> clearMessages(String chatGroupId) async =>
      super.deleteWhere('chat_group_id = ?', [chatGroupId]);

  Future<List<MessageModel>> chatMessages(String chatGroupId) =>
      super.selectByOne('chat_group_id', chatGroupId);

  Future<Message> lastMessage(
      String chatGroupId, Future<Chat> Function(String) chatProvider) async {
    final msgModel = await single('chat_group_id = ?', [chatGroupId]);
    final from = await chatProvider(msgModel.fromId);
    final to = await chatProvider(msgModel.chatGroupId);
    return Message(msgModel.id, msgModel.bodyObj, from, to, msgModel.epoch);
  }

  Future<Message> getMessage(
      String id, Future<Chat> Function(String) chatProvider) async {
    final msgModel = await single('id = ?', [id]);

    final from = await chatProvider(msgModel.fromId);
    final to = await chatProvider(msgModel.chatGroupId);

    return Message(msgModel.id, msgModel.bodyObj, from, to, msgModel.epoch);
  }
}

class MessageModel with sql.ModelBase {
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
