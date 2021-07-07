import 'package:meftun/types/chat.dart' show Chat;
import 'package:meftun/types/directchat.dart' show DirectChat;
import 'package:meftun/types/groupchat.dart' show GroupChat;
import 'package:meftun/types/botchat.dart' show BotChat;
import 'package:meftun/models/chatmodel.dart' show ChatModel, ChatModelFrom;
import 'package:meftun/tables/table_base.dart' show TableBase;
import 'package:meftun/tables/sembast_helper.dart' show SembastHelper;
import 'package:meftun/tables/dbase_manager.dart';
import 'package:meftun/main.dart' show MyStorage;

abstract class ChatTable
    with ChatModelFrom
    implements TableBase<ChatModel, String> {
  static Chat asChat(ChatModel cm) {
    switch (cm.type) {
      case Chat.BOT:
        return BotChat(cm.id, null, cm.displayName);
      case Chat.DIRECT:
        return DirectChat(cm.id, cm.displayName);
      case Chat.GROUP:
      default:
        return GroupChat(cm.id, cm.displayName);
    }
  }

  Future<bool> insertChat(Chat item) async =>
      await insert(ChatModel(item.id, item.displayName, item.type));

  Future<bool> deleteChat(Chat c) async => await deleteOne(key: c.id);

  Future<Chat> getChat(String id) async {
    if (manager.botmasterId == id)
      return BotChat(manager.botmasterId, null, '[BotMaster]');
    if (manager.adminId == id) return DirectChat(manager.adminId, '[admin]');
    final x = await first(key: id);
    if (x == null) return DirectChat('-1', '[unknown_contact]');
    return asChat(x);
  }

  Future<List<Chat>> filterChats(String ftext) async => (ftext != ''
          ? await list(
              orderBy: 'display_name', filter: MapEntry('display_name', ftext))
          : await list())
      .map((cm) => asChat(cm))
      .toList();
}

class SembastChatTable extends ChatTable with SembastHelper<ChatModel, String> {
  final String _name;
  final SembastDbManager _manager;

  SembastChatTable(this._manager, [this._name = 'chats']);

  @override
  String get name => _name;

  @override
  SembastDbManager get manager => _manager;

  @override
  get store => SembastDbManager.getStrMapStore(_name);
}
