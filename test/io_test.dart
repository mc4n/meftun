import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/models/person.dart';
import 'package:me_flutting/widget/textingscreen.dart';

void main() {
  testWidgets('MyWidget test', (WidgetTester tester) async {
    // Test code goes here.

    var myMessages = [Message('oweqow', contacts[0], me.id, me)];

    await tester.pumpWidget(TextingScreen(
      messages: myMessages,
    ));

    expect(true, true);
  });
}
