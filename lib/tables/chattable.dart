import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/directchat.dart' show DirectChat;
import 'package:me_flutting/types/groupchat.dart' show GroupChat;
import 'package:me_flutting/types/botchat.dart' show BotChat;
import 'package:me_flutting/models/chatmodel.dart'
    show ChatModel, ChatModelFrom;
import 'package:me_flutting/tables/table_base.dart' show TableBase;
import 'package:me_flutting/tables/sembast_helper.dart' show SembastHelper;
import 'package:me_flutting/tables/dbase_manager.dart';

abstract class ChatTable
    with ChatModelFrom
    implements TableBase<ChatModel, String> {
  static Chat asChat(ChatModel cm) {
    if (cm == null) return DirectChat('-1', '[deleted_contact]');
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
    final x = await first(key: id);
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
