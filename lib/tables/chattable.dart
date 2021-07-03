import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/directchat.dart' show DirectChat;
import 'package:me_flutting/types/groupchat.dart' show GroupChat;
import 'package:me_flutting/types/botchat.dart' show BotChat;
import 'package:me_flutting/models/chatmodel.dart'
    show ChatModel, ChatModelFrom;
import 'package:me_flutting/tables/table_base.dart' show TableBase;
import 'package:me_flutting/tables/sembast_table.dart' show SembastTable;
import 'package:me_flutting/tables/dbase_manager.dart';

abstract class ChatTable with ChatModelFrom implements TableBase<ChatModel> {
  static Chat asChat(ChatModel cm) {
    if (cm == null) return DirectChat('-1', '[deleted_contact]');
    switch (cm.type) {
      case Chat.BOT:
        return BotChat(cm.id, null, cm.displayName, photoURL: cm.photoURL);
      case Chat.DIRECT:
        return DirectChat(cm.id, cm.displayName, photoURL: cm.photoURL);
      case Chat.GROUP:
      default:
        return GroupChat(cm.id, cm.displayName, photoURL: cm.photoURL);
    }
  }

  Future<bool> insertChat(Chat item) async =>
      insert(ChatModel(item.id, item.displayName, item.photoURL, item.type));

  Future<bool> deleteChat(Chat c) async => delete(c.id);

  Future<Chat> getChat(String id) async {
    final x = await single('id', [id]);
    return asChat(x);
  }

  Future<List<Chat>> chats() async =>
      (await select()).map((cm) => asChat(cm)).toList();

  Future<List<Chat>> filterChats(String ftext) async =>
      (ftext != '' ? await selectWhere('user_name', [ftext]) : await select())
          .map((cm) => asChat(cm))
          .toList();
}

class SembastChatTable extends ChatTable with SembastTable<ChatModel> {
  final String _name;
  final SembastDbManager _manager;

  SembastChatTable(this._manager, [this._name = 'chats']);

  @override
  String get name => _name;

  @override
  SembastDbManager get manager => _manager;

  @override
  get store => SembastDbManager.getStore(_name);
}
