import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/pages/main.dart' show MainPage;
//import '/pages/profile.dart' show ProfilePage;
//import '/helpers/msghelper.dart' show ChatFactory;
//import '/models/directchat.dart' show DirectChat;
//import '/models/mbody.dart' show RawBody;
//import 'dart:math' show Random;
import '/helpers/sql_helper.dart';
import '/helpers/table_helper.dart';

void main() {
  //_initTempObjects();
  runApp(Builder(
      builder: (_) => MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            title: 'Mefluttin',
            home: MainPage(), // ProfilePage(chatFactory.ownerFactory),
          )));
}

final DbaseContext myContext =
    DbaseContext('demo.db', [ChatTable(), MessageTable()]);

/*ChatFactory chatFactory =
    ChatFactory(DirectChat('mcan', 'Mustafa Can', 'pac.jpg'));

void _initTempObjects() {
  chatFactory.addGroup('THUGS');
  final _ = ['2pac', 'bigg', 'cube'];
  _.forEach((__) {
    chatFactory.addPerson(__);
  });
  chatFactory.addGroup('mentals');
  final cts = chatFactory.msgFactories;
  final rnd = Random();
  final exampleMsgs = [
    'Hello World!',
    'The world is mine!',
    'Bang bang',
    'selamun aleyküm'
  ];

  for (final _ in exampleMsgs) {
    final mf = cts.elementAt(rnd.nextInt(cts.length));
    final _msg = mf.addMessageBody(RawBody(_));
    if (rnd.nextInt(2) == 1) mf.addReplyTo(_msg);
  }
}*/

/*class ChatFactory {
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
}*/
