import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/widget/textingscreen.dart';

void main() {
  testWidgets('testTextingWidget', (WidgetTester tester) async {
    await tester.pumpWidget(TextingScreen(
      messages: myMessages,
    ));

    for (var msg in myMessages) {
      expect(find.textContaining(msg.body), findsOneWidget);
    }
  });
}
