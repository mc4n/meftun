import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/helpers/msghelper.dart';
import 'package:me_flutting/models/directchat.dart';

void main() {
  test('test contacts', () async {
    var chatFact = ChatFactory(DirectChat('admin', 'adamin dibi'));
    final peeps = ['2pac', 'bigg', 'cube', 'ali', 'ayse'];
    peeps.forEach((element) {
      chatFact.addPerson(element);
    });
    expect(chatFact.contacts.map((e) => (e as DirectChat).username), peeps);
  });

  test('test messages', () async {
    var chatFact = ChatFactory(DirectChat('admin', 'adamin dibi'));
    final peeps = ['2pac', 'bigg', 'cube', 'ali', 'ayse'];
    peeps.forEach((element) {
      chatFact.addPerson(element);
    });

    final msgFact = chatFact.msgFactories.elementAt(2);

    final body = 'he';

    expect(msgFact.addMessage(body).body, body);

    expect(msgFact.messages.length, 1);
  });
}
