import 'package:me_flutting/types/chat.dart' show Chat;
import 'package:me_flutting/types/directchat.dart' show DirectChat;
import 'package:me_flutting/types/groupchat.dart' show GroupChat;
import 'package:me_flutting/helpers/bot_context.dart' show fillDefaultBots;
import 'package:me_flutting/models/chatmodel.dart' show ChatModel;
import 'table_helpers.dart';

abstract class ChatTable {
  final TableBaseHelper<ChatModel> store;
  ChatTable(this.store);

  static ChatModel from(Map<String, dynamic> _map) => ChatModel(_map['id'],
      _map['user_name'], _map['name'], _map['photo_url'], _map['_type']);

  Future<bool> insertChat(Chat item) async => store.insert(
      ChatModel(item.id, item.username, item.name, item.photoURL, item.type));

  Future<bool> deleteChat(Chat c) async => store.delete(c.id);

  Future<Chat> getChat(String id) async =>
      (await store.single('id = ?', [id])).asChat;

  Future<List<Chat>> chats() async =>
      (await store.select()).map((cm) => cm.asChat).toList();

  Future<List<Chat>> filterChats(String ftext) async => (ftext != ''
          ? await store.selectWhere('user_name = ?', [ftext])
          : await store.select())
      .map((cm) => cm.asChat)
      .toList();
}

class SqlChatTable extends ChatTable {
  SqlChatTable()
      : super(SqlTableHelper<ChatModel>(
            'tb_chats',
            ''' 
              create table tb_chats (
                      id text primary key not null,
                      user_name text not null,
                      name text not null,
                      photo_url text not null,
                _type integer not null)
          ''',
            ChatTable.from));
}

class SafeChatTable extends ChatTable {
  static DirectChat mockSessionOwner =
      DirectChat('1', 'mcan', name: 'Mustafa Can');

  SafeChatTable() : super(SafeTableHelper<ChatModel>(ChatTable.from)) {
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
