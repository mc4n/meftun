import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../models/groupchat.dart' show GroupChat;
import '../models/message.dart' show Message;
import '../models/mbody.dart' show MBody, RawBody;
import 'sql_helper.dart';

class ChatFactory {
  List<MessageFactory> _items = [];
  ChatTable table;
  MessageFactory _addItem(MessageFactory _item) {
    _items.add(_item);
    return _item;
  }

  bool _removeItem(MessageFactory _item) => _items.remove(_item);
  final Chat _owner;
  final meContext = DbaseContext('demo.db', [ChatTable(), MessageTable()]);
  ChatFactory(this._owner) {
    addContact(_owner);
    meContext.tableEntityOf<ChatTable>();
  }

  DirectChat get owner => _owner;

  MessageFactory get ownerFactory => _items.first;

  MessageFactory _chatToFactory(Chat _target) =>
      _items.singleWhere((m) => m.chatItem == _target);

  Iterable<MessageFactory> get msgFactories => _items.skip(1);

  Iterable<Chat> get contacts => msgFactories.map((m) => m.chatItem);

  bool _exists(bool Function(Chat) pred) => contacts.where(pred)?.isNotEmpty;

  bool existsPerson(String uName) =>
      _exists((_) => _ is DirectChat && _.username == uName);

  Chat addContact(Chat item) => _addItem(MessageFactory(this, item)).chatItem;

  DirectChat addPerson(String userName) => addContact(DirectChat(userName));

  GroupChat addGroup(String name) => addContact(GroupChat(name));

  bool removeContact(Chat item) {
    if (!_exists((_) => item == _)) return false;
    _removeItem(_chatToFactory(item));
    return !_exists((_) => item == _);
  }
}

class MessageFactory {
  List<Message> _items = [];
  MessageTable table;
  Message _addItem(Message _item) {
    _items.add(_item);
    return _item;
  }

  bool _removeItem(Message _item) => _items.remove(_item);
  final Chat _base;
  final ChatFactory chatFactory;
  MessageFactory(this.chatFactory, this._base) {
    table = chatFactory.meContext.tableEntityOf<MessageTable>();
  }

  Chat get chatItem => _base;

  Iterable<Message> get messages {
    _items.sort(Message.compareEpoch);
    return _items;
  }

  Message get lastMessage => messages.length > 0 ? messages.last : null;

  Message _addMessage(Message item) => _addItem(item);

  Message addMessageBody(MBody body) =>
      _addMessage(chatItem.createMessage(chatFactory.owner, body));

  Message addReplyTo(Message msg) => _addResponse(msg.chatGroup);

  Message _addResponse(GroupChat chatGroup) {
    final cts = chatFactory.contacts
        .where((x) => x is DirectChat)
        .map((x) => x as DirectChat)
        .take(chatGroup.maximumParticipants);
    var newFrom = chatGroup.maximumParticipants == 2
        ? chatGroup
        : cts.elementAt(DateTime.now().millisecond % cts.length);
    var newTo =
        chatGroup.maximumParticipants == 2 ? chatFactory.owner : chatItem;
    return _addMessage(newTo.createMessage(
        newFrom, RawBody('a response by ${newFrom.caption}')));
  }

  bool removeMessage(Message item) {
    if (_items.contains(item)) return _removeItem(item);
    return false;
  }

  void clearMessages() => _items.clear();

  // ------

  bool fContactsFilter(bool isSearching, String ftext) =>
      lastMessage?.body == null &&
      (!isSearching ||
          ftext == '' ||
          isSearching && ftext != '' && _base.caption.contains(ftext));

  bool fChatsFilter(bool isSearching, String ftext) =>
      lastMessage?.body != null &&
      (!isSearching ||
          ftext == '' ||
          isSearching && ftext != '' && _base.caption.contains(ftext));
}

//

class ChatTable extends TableEntity<ChatModel> {
  ChatTable()
      : super(
            'tb_chats',
            'id nvarchar(200) primary key not null,'
                'username nvarchar(15) not null,'
                'name nvarchar(200) not null,'
                'type integer not null');

  @override
  ChatModel from(Map<String, dynamic> _map) {
    return ChatModel(
      _map['id'],
      _map['username'],
      _map['name'],
      _map['type'],
    );
  }
}

class MessageTable extends TableEntity<MessageModel> {
  MessageTable()
      : super(
            'tb_messages',
            'id nvarchar(200) primary key not null,'
                'body nvarchar(900) not null,'
                'from_id nvarchar(200) not null,'
                'chat_group_id nvarchar(200) not null,'
                'epoch integer not null');

  @override
  MessageModel from(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
    );
  }
}

class ChatModel with ModelBase {
  final String id;
  final String userName;
  final String name;
  final int type;
  const ChatModel(this.id, this.userName, this.name, this.type);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'username': userName,
        'name': name,
        'type': type,
      };
}

class MessageModel with ModelBase {
  final String id;
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  const MessageModel(
      this.id, this.body, this.fromId, this.chatGroupId, this.epoch);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
      };
}
