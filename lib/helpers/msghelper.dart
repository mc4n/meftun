import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/groupchat.dart';
import 'package:me_flutting/models/message.dart';

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
}

class ChatFactory extends Factory<MessageFactory> {
  ChatFactory(DirectChat _owner) : super(_owner) {
    _items.add(MessageFactory(this, _owner));
  }

  DirectChat get owner => _base;

  MessageFactory get ownerFactory => _items.first;

  MessageFactory factoryByChat(Chat _target) =>
      _items.singleWhere((m) => m.chatItem == _target);

  Iterable<MessageFactory> get msgFactories => _items.skip(1);

  Iterable<Chat> get contacts => msgFactories.map((m) => m.chatItem);

  Chat addContact(Chat target) =>
      _addItem(MessageFactory(this, target)).chatItem;

  DirectChat addPerson(String userName) => addContact(DirectChat(userName));

  GroupChat addGroup(String name) => addContact(GroupChat(name));
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

  Message addMessage(Message msg) => _addItem(msg);

  Message addMessageBodyFrom(DirectChat from, String body) =>
      addMessage(chatItem.createMessage(from, body));

  Message addMessageBody(String body) =>
      addMessage(chatItem.createMessage(chatFactory.owner, body));

  Message addResponse(Message msg) {
    final cts = chatFactory.contacts
        .where((x) => x is DirectChat)
        .map((x) => x as DirectChat);
    var newFrom = cts.elementAt(DateTime.now().millisecond % cts.length);
    if (msg.chatGroup is GroupChat) {
      return chatFactory.factoryByChat(msg.chatGroup).addMessageBodyFrom(
          newFrom, 'this is an example response by ${newFrom.caption}');
    } else {
      var newFrom = msg.chatGroup as DirectChat;
      var ownerF = chatFactory.ownerFactory;
      return ownerF.addMessageBodyFrom(
          newFrom, 'this is an example response by ${newFrom.caption}');
    }
  }

  // ------
  bool get fNotContact => lastMessage?.body != null;

  bool fContactsFilter(bool isSearching, String ftext) =>
      !fNotContact &&
      (!isSearching ||
          ftext == '' ||
          isSearching && ftext != '' && _base.caption.contains(ftext));

  bool fChatsFilter(bool isSearching, String ftext) =>
      fNotContact &&
      (!isSearching ||
          ftext == '' ||
          isSearching && ftext != '' && _base.caption.contains(ftext));
}
