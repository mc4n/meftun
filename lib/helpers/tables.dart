import '../models/chat.dart' show Chat;
import '../models/message.dart' show Message;
import '../models/draft.dart' show Draft;
import 'models.dart';
import 'table_helper.dart';

abstract class BaseTable<T extends ModelBase> {
  final TableBaseHelper<T> _store;
  BaseTable(this._store);
}

abstract class ChatTable extends BaseTable<ChatModel> {
  ChatTable(TableBaseHelper<ChatModel> _store) : super(_store);

  static ChatModel from(Map<String, dynamic> _map) => ChatModel(_map['id'],
      _map['user_name'], _map['name'], _map['photo_url'], _map['_type']);

  Future<bool> insertChat(Chat item) async => _store.insert(
      ChatModel(item.id, item.username, item.name, item.photoURL, item.type));

  Future<bool> deleteChat(Chat c) async => _store.delete(c.id);

  Future<Chat> getChat(String id) async =>
      (await _store.single('id = ?', [id])).asChat;

  Future<List<Chat>> chats() async =>
      (await _store.select()).map((cm) => cm.asChat).toList();

  Future<List<Chat>> filterChats(String ftext) async => (ftext != ''
          ? await _store.selectWhere('user_name = ?', [ftext])
          : await _store.select())
      .map((cm) => cm.asChat)
      .toList();
}

abstract class MessageTable extends BaseTable<MessageModel> {
  MessageTable(TableBaseHelper<MessageModel> _store) : super(_store);

  static MessageModel from(Map<String, dynamic> _map) {
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
    _store.insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
    return item;
  }

  Future<bool> deleteMessage(Message msg) async => _store.delete(msg.id);

  Future<bool> clearMessages(String chatGroupId) async =>
      _store.deleteWhere('chat_group_id = ?', [chatGroupId]);

  Future<List<Message>> chatMessages(
      String chatGroupId, Future<Chat> Function(String) chatProvider) async {
    final _trans = (model) async => getMessage(model.id, chatProvider);
    final _res = await _store.selectWhere('chat_group_id = ?', [chatGroupId],
        orderBy: 'epoch ASC');
    final List<Message> msgs = [];
    for (final _ in _res) msgs.add(await _trans(_));
    return msgs;
  }

  // idareten ...
  Future<List<double>> countMessages(int start, int end, Chat me) async {
    final sel = await _store.select();
    final total =
        sel.where((m) => m.epoch >= start && m.epoch <= end).length as double;
    final mines = sel
        .where((m) => m.epoch >= start && m.epoch <= end && m.fromId == me.id)
        .length as double;
    return [mines, total - mines];
  }

  Future<Message> lastMessage(String chatGroupId,
          Future<Chat> Function(String) chatProvider) async =>
      asMessage(
          await _store.single('chat_group_id = ?', [chatGroupId],
              orderBy: 'epoch DESC'),
          chatProvider);

  Future<Message> getMessage(
          String id, Future<Chat> Function(String) chatProvider) async =>
      asMessage(await _store.single('id = ?', [id]), chatProvider);

  Future<Message> asMessage(
      MessageModel msgModel, Future<Chat> Function(String) chatProvider) async {
    final from = await chatProvider(msgModel.fromId);
    final to = await chatProvider(msgModel.chatGroupId);
    return Message(msgModel.id, msgModel.bodyObj, from, to, msgModel.epoch);
  }
}

class SqlChatTable extends ChatTable {
  SqlChatTable() : super(SqlTableHelper<ChatModel>('tb_chats', ChatTable.from));
}

class SafeChatTable extends ChatTable {
  SafeChatTable() : super(SafeTableHelper<ChatModel>(ChatTable.from));
}

class SqlMessageTable extends MessageTable {
  SqlMessageTable()
      : super(SqlTableHelper<MessageModel>('tb_messages', MessageTable.from));
}

class SafeMessageTable extends MessageTable {
  SafeMessageTable() : super(SafeTableHelper<MessageModel>(MessageTable.from));
}
