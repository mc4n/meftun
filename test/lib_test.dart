import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/helpers/msghelper.dart';

void main() {
  // test('test contacts', () async {
  //   var chatFact = ChatFactory(DirectChat('admin', 'adamin dibi'));
  //   final peeps = ['2pac', 'bigg', 'cube', 'ali', 'ayse'];
  //   peeps.forEach((element) {
  //     chatFact.addPerson(element);
  //   });

  //   expect(chatFact.contacts.map((e) => (e as DirectChat).username), peeps);
  // });

  test('test remove contact', () async {
    var chatFact = ChatFactory(DirectChat('admin', 'adamin dibi'));
    final peeps = ['ali', 'ayse'];
    peeps.forEach((element) {
      chatFact.addPerson(element);
    });
    expect(chatFact.contacts.map((e) => (e as DirectChat).username), peeps);
    expect(chatFact.contacts.length, peeps.length);
    var celal = chatFact.addPerson('celal');
    expect(chatFact.contacts.length, peeps.length + 1);
    expect(chatFact.existsPerson('celal'), true);
    expect(chatFact.removeContact(celal), true);
    expect(chatFact.existsPerson('celal'), false);
    expect(chatFact.contacts.length, peeps.length);
    expect(chatFact.removeContact(DirectChat('hedehede')), false);
    expect(chatFact.contacts.length, peeps.length);
  });

  // test('test messages', () async {
  //   var chatFact = ChatFactory(DirectChat('admin', 'adamin dibi'));
  //   final peeps = ['2pac', 'bigg', 'cube', 'ali', 'ayse'];
  //   peeps.forEach((element) {
  //     chatFact.addPerson(element);
  //   });

  //   final msgFact = chatFact.msgFactories.elementAt(2);

  //   final body = 'he';

  //   var msg = msgFact.addMessageBody(body);

  //   expect(msg.body, body);

  //   final resp = msgFact.addResponse(msg);

  //   expect(
  //       resp.body, 'this is an example response by ${msg.chatGroup.caption}');

  //   expect(msgFact.messages.toList().length, 2);
  // });

  // test('test epoch to time', () async {
  //   var dt = DateTime.fromMillisecondsSinceEpoch(
  //       DateTime.now().millisecondsSinceEpoch - 4000000000);

  //   var diff = dt.difference(DateTime.now());

  //   print(diff.abs().toString() +
  //       (diff.isNegative ? diff.inDays.toString() + ' days ago' : ' '));
  //   //expect(newMsg.epochToTimeString(), '');
  // });
}
