import 'package:uuid/uuid.dart';
import 'chat.dart' show Chat;
import 'message.dart' show Message;
import 'directchat.dart' show DirectChat;
import 'mbody.dart' show MBody;

class Draft {
  static Uuid uuid = Uuid();
  MBody body;
  final DirectChat from;
  final Chat chatGroup;
  final Message quoteTo;
  Draft(this.body, this.from, this.chatGroup, [this.quoteTo]);

  set setBody(MBody body) => this.body = body;

  Message toMessage() {
    var _msg = Message(body, from, uuid.v4(), chatGroup);
    return _msg;
  }

  @override
  String toString() => '[Draft]\n body: $body}';
}
