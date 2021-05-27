import 'package:uuid/uuid.dart';
import 'chat.dart';
import 'message.dart';
import 'directchat.dart';

class Draft {
  static Uuid uuid = Uuid();
  String body;
  final DirectChat from;
  final Chat chatGroup;

  Draft(this.body, this.from, this.chatGroup);

  set setBody(String body) => this.body = body;

  Message toMessage() {
    var _msg = Message(body, from, uuid.v4(), chatGroup);
    return _msg;
  }

  @override
  String toString() {
    return '[Draft]\n body: $body \n chatgroup.id?: ${chatGroup?.id}';
  }
}
