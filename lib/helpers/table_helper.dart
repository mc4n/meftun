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

  Future<List<T>> _select({int pageNum = 0, String orderBy = 'id ASC'}) async =>
      sql.query(tableName, from,
          orderBy: orderBy, limit: PAGE_LEN, offset: pageNum * PAGE_LEN);

  Future<List<T>> _selectWhere(String _where, List<dynamic> whereArgs,
          {int pageNum = 0, String orderBy = 'id ASC'}) async =>
      sql.query(tableName, from,
          where: _where,
          whereArgs: whereArgs,
          orderBy: orderBy,
          limit: PAGE_LEN,
          offset: pageNum * PAGE_LEN);

  Future<T> _single(String _where, List<dynamic> whereArgs,
      {String orderBy = 'id ASC'}) async {
    final res = (await sql.query(tableName, from,
        where: _where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: 1,
        offset: 0));
    return res != null && res.length == 1 ? res.first : null;
  }

  Future<bool> _insert(T item) async => (await sql.insert(tableName, item)) > 0;

  Future<bool> _deleteWhere(String _where, List<dynamic> whereArgs) async =>
      (await sql.delete(tableName, _where, whereArgs)) > 0;

  Future<bool> _delete(String id) async => _deleteWhere('id = ?', [id]);
}

abstract class SafeTableEntity<T extends sql.ModelBase> extends TableEntity<T> {
  List<Map<String, dynamic>> _itemStore = [];

  SafeTableEntity(String tbName) : super(tbName);

  @override
  Future<List<T>> _select({int pageNum = 0, String orderBy = 'id ASC'}) async =>
      _itemStore.map((m) => from(m)).toList();

  @override
  Future<List<T>> _selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy = 'id ASC'}) async {
    if (whereArgs.length == 1) {
      final cond = _where.replaceAll('= ?', '').trim();
      final ls = _itemStore.where((m) => m[cond] == whereArgs[0]);
      return ls.map((m) => from(m)).toList();
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<T> _single(String _where, List<dynamic> whereArgs,
      {String orderBy = 'id ASC'}) async {
    final ls = await _selectWhere(_where, whereArgs, orderBy: orderBy);
    return ls != null && ls.length > 0 ? ls.last : null;
  }

  @override
  Future<bool> _insert(T item) async {
    _itemStore.add(item.map);
    return _exists('id', item.getId);
  }

  @override
  Future<bool> _deleteWhere(String _where, List<dynamic> whereArgs) async {
    if (whereArgs.length == 1) {
      final cond = _where.replaceAll('= ?', '').trim();
      _itemStore.removeWhere((m) => m[cond] == whereArgs[0]);
      return !(await _exists(cond, whereArgs[0]));
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<bool> _delete(String id) async => _deleteWhere('id = ?', [id]);

  Future<bool> _exists(String key, dynamic value) async =>
      _itemStore.any((m) => m[key] == value);
}

// ----- TABLES -----

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

  Future<bool> insertChat(Chat item) async => super._insert(
      ChatModel(item.id, item.username, item.name, item.photoURL, item.type));

  Future<bool> deleteChat(Chat c) async => super._delete(c.id);

  Future<Chat> getChat(String id) async =>
      (await super._single('id = ?', [id])).asChat;

  Future<List<Chat>> chats() async =>
      (await super._select()).map((cm) => cm.asChat).toList();

  Future<List<Chat>> filterChats(String ftext) async => (ftext != ''
          ? await super._selectWhere('user_name = ?', [ftext])
          : await super._select())
      .map((cm) => cm.asChat)
      .toList();
}

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
    _insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
    return item;
  }

  Future<bool> deleteMessage(Message msg) async => super._delete(msg.id);

  Future<bool> clearMessages(String chatGroupId) async =>
      super._deleteWhere('chat_group_id = ?', [chatGroupId]);

  Future<List<Message>> chatMessages(
      String chatGroupId, Future<Chat> Function(String) chatProvider) async {
    final _trans = (model) async => getMessage(model.id, chatProvider);
    final _res = await super
        ._selectWhere('chat_group_id = ?', [chatGroupId], orderBy: 'epoch ASC');
    final List<Message> msgs = [];
    for (final _ in _res) msgs.add(await _trans(_));
    //msgs.sort(Message.compareEpoch);
    return msgs;
  }

  Future<Message> lastMessage(String chatGroupId,
          Future<Chat> Function(String) chatProvider) async =>
      asMessage(
          await _single('chat_group_id = ?', [chatGroupId],
              orderBy: 'epoch DESC'),
          chatProvider);

  Future<Message> getMessage(
          String id, Future<Chat> Function(String) chatProvider) async =>
      asMessage(await _single('id = ?', [id]), chatProvider);

  Future<Message> asMessage(
      MessageModel msgModel, Future<Chat> Function(String) chatProvider) async {
    final from = await chatProvider(msgModel.fromId);
    final to = await chatProvider(msgModel.chatGroupId);
    return Message(msgModel.id, msgModel.bodyObj, from, to, msgModel.epoch);
  }
}

// ------ MODELS ----

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
