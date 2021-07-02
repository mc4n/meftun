import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/message.dart' show Message;
import 'package:me_flutting/types/mbody.dart' show MBody, RawBody, ImageBody;
import 'package:me_flutting/types/draft.dart' show Draft;
import 'package:me_flutting/models/messagemodel.dart'
    show MessageModel, MessageModelFrom;
import 'package:me_flutting/tables/table_base.dart' show TableBase;
import 'package:me_flutting/tables/sembast_table.dart' show SembastTable;
import 'package:me_flutting/tables/dbase_manager.dart';

abstract class MessageTable
    with MessageModelFrom
    implements TableBase<MessageModel> {
  static MBody bodyObj(MessageModel mm) {
    switch (mm.mbodyType) {
      case MBody.IMAGE_MESSAGE:
        return ImageBody(mm.body);
      case MBody.FILE_MESSAGE:
      case MBody.JSON_MESSAGE:
      case MBody.RAW_MESSAGE:
      default:
        return RawBody(mm.body);
    }
  }

  Future<Message> insertMessage(Draft dr) async {
    final item = dr is Message ? dr : dr.toMessage();
    await insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
    return item;
  }

  Future<bool> deleteMessage(Message msg) async => delete(msg.id);

  Future<bool> clearMessages(String chatGroupId) async =>
      deleteWhere('chat_group_id', [chatGroupId]);

  Future<List<Message>> chatMessages(
      String chatGroupId, Future<Chat> Function(String) chatProvider) async {
    final _trans = (model) async => getMessage(model.id, chatProvider);
    final _res =
        await selectWhere('chat_group_id', [chatGroupId], orderBy: 'epoch');
    final List<Message> msgs = [];
    for (final _ in _res) msgs.add(await _trans(_));
    return msgs;
  }

  // idareten ...
  Future<List<double>> countMessages(int start, int end, Chat me) async {
    final sel = await select();
    final total =
        sel.where((m) => m.epoch >= start && m.epoch <= end).length as double;
    final mines = sel
        .where((m) => m.epoch >= start && m.epoch <= end && m.fromId == me.id)
        .length as double;
    return [mines, total - mines];
  }

  Future<Message> lastMessage(String chatGroupId,
          Future<Chat> Function(String) chatProvider) async =>
      asMessage(await single('chat_group_id', [chatGroupId], orderBy: 'epoch'),
          chatProvider);

  Future<Message> getMessage(
          String id, Future<Chat> Function(String) chatProvider) async =>
      asMessage(await single('id', [id], orderBy: 'epoch'), chatProvider);

  Future<Message> asMessage(
      MessageModel msgModel, Future<Chat> Function(String) chatProvider) async {
    final from = await chatProvider(msgModel.fromId);
    final to = await chatProvider(msgModel.chatGroupId);
    return Message(msgModel.id, bodyObj(msgModel), from, to, msgModel.epoch);
  }
}

class SembastMessageTable extends MessageTable with SembastTable<MessageModel> {
  final String _name;
  final SembastDbManager _manager;

  SembastMessageTable(this._manager, [this._name = 'messages']);

  @override
  String get name => _name;

  @override
  SembastDbManager get manager => _manager;

  @override
  get store => SembastDbManager.getStore(_name);
}
