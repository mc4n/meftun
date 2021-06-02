import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../models/groupchat.dart' show GroupChat;
import '../models/message.dart' show Message;

class Factory<T> {
  List<T> _items = [];
  // ignore: unused_field
  final Chat _base;
  Factory(this._base);
  // ignore: unused_element
  T _lastItem() => _items.last;
  // ignore: unused_element
  T _addItem(T _item) {
    _items.add(_item);
    return _item;
  }

  bool _removeItem(T _item) => _items.remove(_item);
}

class ChatFactory extends Factory<MessageFactory> {
  ChatFactory(DirectChat _owner) : super(_owner) {
    _items.add(MessageFactory(this, _owner));
  }

  DirectChat get owner => _base;

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

class MessageFactory extends Factory<Message> {
  final ChatFactory chatFactory;
  MessageFactory(this.chatFactory, Chat target) : super(target) {
    addMessageBody(null);
  }

  Chat get chatItem => _base;

  Iterable<Message> get messages {
    var list = <Message>[];

    list.addAll(chatFactory.ownerFactory._items
        .where((m) => m.body != null && m.from == chatItem));

    list.addAll(_items.where((m) => m.body != null && m.chatGroup == chatItem));

    list.sort(Message.compareEpoch);
    return list;
  }

  Message get lastMessage => messages.length > 0 ? messages.last : null;

  Message addMessage(Message item) => _addItem(item);

  Message addMessageBodyFrom(DirectChat from, String body) =>
      addMessage(chatItem.createMessage(from, body));

  Message addMessageBody(String body) =>
      addMessageBodyFrom(chatFactory.owner, body);

  Message addReplyTo(Message msg) => _addResponseFrom(msg.chatGroup);

  Message _addResponseFrom(Chat newFrom) {
    final cts = chatFactory.contacts
        .where((x) => x is DirectChat)
        .map((x) => x as DirectChat);
    var newFrom = cts.elementAt(DateTime.now().millisecond % cts.length);
    if (newFrom is GroupChat) {
      return chatFactory._chatToFactory(newFrom).addMessageBodyFrom(
          newFrom, 'this is an example response by ${newFrom.caption}');
    } else {
      var ownerF = chatFactory.ownerFactory;
      return ownerF.addMessageBodyFrom(
          newFrom, 'this is an example response by ${newFrom.caption}');
    }
  }

  bool removeMessage(Message item) {
    if (_items.contains(item)) return _removeItem(item);
    return false;
  }

  void clearMessages() {
    var f = chatFactory._chatToFactory(chatItem);
    if (chatItem is DirectChat)
      chatFactory.ownerFactory._items.removeWhere((_) => _.from == chatItem);
    f._items.removeWhere((m) => m.chatGroup == chatItem);
  }

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
