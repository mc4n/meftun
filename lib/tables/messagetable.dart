import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/message.dart' show Message;
import 'package:me_flutting/types/mbody.dart' show RawBody;
import 'package:me_flutting/types/draft.dart' show Draft;
import 'package:me_flutting/types/directchat.dart' show DirectChat;
import 'package:me_flutting/types/groupchat.dart' show GroupChat;
import 'package:me_flutting/helpers/table_helpers.dart';
import 'package:me_flutting/models/messagemodel.dart' show MessageModel;
import 'basetable.dart';
import 'chattable.dart';

abstract class MessageTable extends BaseTable<MessageModel> {
  MessageTable(TableBaseHelper<MessageModel> store) : super(store);

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
    store.insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
    return item;
  }

  Future<bool> deleteMessage(Message msg) async => store.delete(msg.id);

  Future<bool> clearMessages(String chatGroupId) async =>
      store.deleteWhere('chat_group_id = ?', [chatGroupId]);

  Future<List<Message>> chatMessages(
      String chatGroupId, Future<Chat> Function(String) chatProvider) async {
    final _trans = (model) async => getMessage(model.id, chatProvider);
    final _res = await store.selectWhere('chat_group_id = ?', [chatGroupId],
        orderBy: 'epoch ASC');
    final List<Message> msgs = [];
    for (final _ in _res) msgs.add(await _trans(_));
    return msgs;
  }

  // idareten ...
  Future<List<double>> countMessages(int start, int end, Chat me) async {
    final sel = await store.select();
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
          await store.single('chat_group_id = ?', [chatGroupId],
              orderBy: 'epoch DESC'),
          chatProvider);

  Future<Message> getMessage(
          String id, Future<Chat> Function(String) chatProvider) async =>
      asMessage(await store.single('id = ?', [id]), chatProvider);

  Future<Message> asMessage(
      MessageModel msgModel, Future<Chat> Function(String) chatProvider) async {
    final from = await chatProvider(msgModel.fromId);
    final to = await chatProvider(msgModel.chatGroupId);
    return Message(msgModel.id, msgModel.bodyObj, from, to, msgModel.epoch);
  }
}

class SqlMessageTable extends MessageTable {
  SqlMessageTable()
      : super(SqlTableHelper<MessageModel>(
            'tb_messages',
            ''' 
          create table tb_messages (
              id text primary key not null,
                      body text not null,
                      from_id text not null,
                      chat_group_id text not null,
                      epoch integer not null,
                      mbody_type text not null)
          ''',
            MessageTable.from));
}

class SafeMessageTable extends MessageTable {
  SafeMessageTable() : super(SafeTableHelper<MessageModel>(MessageTable.from)) {
    final pac = DirectChat('2', 'pac', name: 'Tupac Shakur');
    final thugs = GroupChat('3', 'THUGS');
    final big = DirectChat('4', 'big', name: 'Notorious BIG');
    insertMessage(Message('4', RawBody('maan, f this sh.'),
        SafeChatTable.mockSessionOwner, big, 1542450000000));
    insertMessage(
        Message('1', RawBody('whutsup bro?'), pac, pac, 1042342000000));
    insertMessage(
        Message('3', RawBody('yeah, indeed.'), big, thugs, 1622450000000));
    insertMessage(
        Message('2', RawBody('thug 4 life!'), pac, thugs, 1027675000000));
  }
}
