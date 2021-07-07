import 'package:meftun/types/message.dart' show Message;
import 'package:meftun/types/mbody.dart' show MBody, RawBody, ImageBody;
import 'package:meftun/types/draft.dart' show Draft;
import 'package:meftun/models/messagemodel.dart'
    show MessageModel, MessageModelFrom;
import 'package:meftun/tables/table_base.dart' show TableBase;
import 'package:meftun/tables/sembast_helper.dart' show SembastHelper;
import 'package:meftun/tables/dbase_manager.dart';
import 'package:meftun/main.dart' show MyStorage;

abstract class MessageTable
    with MessageModelFrom
    implements TableBase<MessageModel, String> {
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

  Future<bool> deleteMessage(Message msg) async => await deleteOne(key: msg.id);

  Future<bool> clearMessages(String chatGroupId) async =>
      await deleteAll(filter: MapEntry('==chat_group_id', chatGroupId));

  Future<List<Message>> chatMessages(String chatGroupId) async {
    final _trans = (model) async => getMessage(model.id);
    final _res = await list(
        filter: MapEntry('chat_group_id', chatGroupId), orderBy: 'epoch');
    final List<Message> msgs = [];
    for (final _ in _res) msgs.add(await _trans(_));
    return msgs;
  }

  Future<List<double>> countMessages(int start, int end) async {
    final total = (await count(
            filter: MapEntry(
                '&&', [MapEntry('>=epoch', start), MapEntry('<=epoch', end)])))
        as double;
    final mines = (await count(
        filter: MapEntry('&&', [
      MapEntry('>=epoch', start),
      MapEntry('<=epoch', end),
      MapEntry('from_id', manager.adminId)
    ]))) as double;
    return [mines, total - mines];
  }

  Future<Message> getMessage(String id) async =>
      asMessage(await first(key: id));

  Future<Message> asMessage(MessageModel msgModel) async {
    final from = await manager.chatTable.getChat(msgModel.fromId);
    final to = await manager.chatTable.getChat(msgModel.chatGroupId);
    return Message(msgModel.id, bodyObj(msgModel), from, to, msgModel.epoch);
  }

  Future<List<Message>> get lastMessages async {
    final ls = await list(orderBy: '-epoch');
    final chatIds = <String>{};
    final returnMsgs = <Message>[];
    for (final item in ls) {
      final _ = item.chatGroupId;
      if (chatIds.contains(_)) continue;
      chatIds.add(_);
      returnMsgs.add(await asMessage(item));
    }
    return returnMsgs;
  }
}

class SembastMessageTable extends MessageTable
    with SembastHelper<MessageModel, String> {
  final String _name;
  final SembastDbManager _manager;

  SembastMessageTable(this._manager, [this._name = 'messages']);

  @override
  String get name => _name;

  @override
  SembastDbManager get manager => _manager;

  @override
  get store => SembastDbManager.getStrMapStore(_name);
}
