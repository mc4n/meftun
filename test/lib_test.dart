import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/person.dart';

void main() {
  // test('testCreateMsg', () async {
  //   var draft = Draft(me, contacts[0]);
  //   var msg = draft.toMessage();
  //   expect(msg.id, isNotNull);
  // });

  test('testgetMsg', () async {
    var chatList = contacts.map((e) => e.getLastMessage()).toList();

    // chatList.forEach((element) {
    //   print(element);
    // });

    expect(chatList, isNotNull);

    // var tx = chatList[0].chatGroup.getMessages().toList();

    // tx.forEach((element) {
    //   print(element);
    // });

    // expect(tx.length, 0);
  });
}
