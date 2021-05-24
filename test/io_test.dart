import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/person.dart';
import 'package:me_flutting/widget/chatitem.dart';

void main() {
  // testWidgets('testTextingWidget', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //       home: TextingScreen(
  //     messages: myMessages,
  //   )));

  //   for (var msg in myMessages) {
  //     if (msg.body.contains('wrworwor')) continue;
  //     expect(find.textContaining(msg.body), findsOneWidget);
  //   }
  // });

  testWidgets('testChatItemWidget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatItem(chatItem: contacts[0])));

    expect(
        find.textContaining(contacts[0].getLastMessage().body), findsOneWidget);
  });
}
