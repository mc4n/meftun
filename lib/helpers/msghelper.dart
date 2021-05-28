import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/draft.dart';
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

    msgFact.addMessage(msgFact.contacts.first, "looooooo");

    expect(msgFact.getMessages(msgFact.contacts.first).length, 2);

    expect(msgFact.getMessages(msgFact.contacts.first).last is Message, true);
  });
}

class MessageFactory {
  Map<Chat, List<Draft>> _items = Map();
  final DirectChat _owner;

  MessageFactory(this._owner);

  DirectChat get owner => _owner;

  Iterable<Draft> getMessages(Chat target) => _items[target];

  Draft getLastMessage(Chat target) => getMessages(target)
      .lastWhere((element) => true, orElse: () => target.createDraft(_owner));

  Iterable<Chat> get contacts => _items.keys;

  void addMessage(Chat target, String body) {
    var dr = target.createDraft(_owner);
    dr.setBody = body;
    _items[target].add(dr.toMessage());
  }

  void addContact(Chat target) {
    _items.putIfAbsent(target, () => [target.createDraft(_owner)]);
  }

  void addPerson(String userName) {
    var target = DirectChat(userName);
    _items.putIfAbsent(target, () => [target.createDraft(owner)]);
  }
}
