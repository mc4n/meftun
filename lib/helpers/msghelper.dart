import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/message.dart';

void main() {
  test('test contacts', () async {
    var msgFact = MessageFactory(DirectChat('admin', 'adamin dibi'));
    var peeps = ['2pac', 'bigg', 'cube', 'ali', 'ayse'];

    peeps.forEach((element) {
      msgFact.addPerson(element);
    });

    expect(msgFact.contacts.map((e) => (e as DirectChat).username), peeps);
  });

  test('test contacts', () async {
    var msgFact = MessageFactory(DirectChat('admin', 'adamin dibi'));
    ['2pac', 'bigg', 'cube', 'ali', 'ayse'].forEach((element) {
      msgFact.addPerson(element);
    });

    msgFact.sendMessage(msgFact.contacts.first, "looooooo");

    msgFact.receiveMessage(msgFact.contacts.first, "??");

    expect(msgFact.getMessages(msgFact.contacts.first).length, 3);

    expect(msgFact.getMessages(msgFact.contacts.first).last is Message, true);
  });
}

class MessageFactory {
  Map<Chat, List<Message>> _items = Map();
  final DirectChat _owner;

  MessageFactory(this._owner) {
    addContact(owner);
  }

  DirectChat get owner => _owner;

  Iterable<Message> getMessages(Chat target) {
    var list =
        _items[target].where((element) => element is Message).toList() ?? [];
    var twoo = (_items[owner].where((element) => element is Message) ?? [])
        .where((element) => element.from == target)
        .toList();
    list.addAll(twoo);
    list.sort((_d1, _d2) {
      // comparison
      var ep1 = _d1.epoch;
      var ep2 = _d2.epoch;
      if (ep1 > ep2)
        return 1;
      else if (ep2 > ep1) return -1;
      return 0;
    });
    return list;
  }

  Message getLastMessage(Chat target) =>
      getMessages(target).lastWhere((element) => true,
          orElse: () => target.createDraft(_owner).toMessage());

  Iterable<Chat> get contacts =>
      _items.keys.where((element) => element != owner);

  void sendMessage(Chat target, String body) {
    var dr = target.createDraft(_owner);
    dr.setBody = body;
    _items[target].add(dr.toMessage());
  }

  void receiveMessage(Chat from, String body) {
    var dr = owner.createDraft(from);
    dr.setBody = body;
    _items[owner].add(dr.toMessage());
  }

  void addContact(Chat target) {
    _items.putIfAbsent(target, () => [target.createDraft(_owner).toMessage()]);
  }

  void addPerson(String userName) {
    var target = DirectChat(userName);
    _items.putIfAbsent(target, () => [target.createDraft(owner).toMessage()]);
  }
}
