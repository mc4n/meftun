import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/directchat.dart' show DirectChat;
import 'package:me_flutting/types/groupchat.dart' show GroupChat;
import 'package:me_flutting/types/botchat.dart' show BotChat;
import 'package:me_flutting/helpers/bot_context.dart' show fillDefaultBots;
import 'package:me_flutting/models/chatmodel.dart'
    show ChatModel, ChatModelFrom;
import 'table_helpers.dart';

abstract class ChatTable
    with ChatModelFrom
    implements TableBaseHelper<ChatModel> {
  static Chat asChat(ChatModel cm) {
    switch (cm.type) {
      case Chat.BOT:
        return BotChat(cm.id, null, cm.userName,
            name: cm.name, photoURL: cm.photoURL);
      case Chat.DIRECT:
        return DirectChat(cm.id, cm.userName,
            name: cm.name, photoURL: cm.photoURL);
      case Chat.GROUP:
      default:
        return GroupChat(cm.id, cm.userName,
            name: cm.name, photoURL: cm.photoURL);
    }
  }

  Future<bool> insertChat(Chat item) async => insert(
      ChatModel(item.id, item.username, item.name, item.photoURL, item.type));

  Future<bool> deleteChat(Chat c) async => delete(c.id);

  Future<Chat> getChat(String id) async => asChat(await single('id = ?', [id]));

  Future<List<Chat>> chats() async =>
      (await select()).map((cm) => asChat(cm)).toList();

  Future<List<Chat>> filterChats(String ftext) async => (ftext != ''
          ? await selectWhere('user_name = ?', [ftext])
          : await select())
      .map((cm) => asChat(cm))
      .toList();
}

class SafeChatTable extends ChatTable with SafeTableHelper<ChatModel> {
  static DirectChat mockSessionOwner =
      DirectChat('1', 'mcan', name: 'Mustafa Can');

  SafeChatTable() {
    final pac = DirectChat('2', 'pac', name: 'Tupac Shakur');
    final thugs = GroupChat('3', 'THUGS');
    final big = DirectChat('4', 'big', name: 'Notorious BIG');
    insertChat(SafeChatTable.mockSessionOwner);
    fillDefaultBots(this);
    insertChat(pac);
    insertChat(thugs);
    insertChat(big);
  }
}
