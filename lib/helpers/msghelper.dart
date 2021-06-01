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
    _items.add(target.createMessage(chatFactory.owner, null));
  }

  Chat get chatItem => _base;

  Iterable<Message> get messages {
    _items.sort(Message.compareEpoch);
    return _items;
  }

  Message get lastMessage => messages.length > 0 ? messages.last : null;

  Message addMessage(String body) => null;

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
