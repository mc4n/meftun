import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/helpers/msghelper.dart';
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
    msgFact.receiveMessage(msgFact.contacts.last, msgFact.contacts.first, "??");
    expect(msgFact.getMessages(msgFact.contacts.first).length, 3);
    expect(msgFact.getMessages(msgFact.contacts.first).last is Message, true);
  });
}
