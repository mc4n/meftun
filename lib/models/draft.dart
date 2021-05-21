import 'package:uuid/uuid.dart';

import 'chat.dart';
import 'message.dart';
import 'person.dart';

class Draft {
  static Uuid uuid = Uuid();
  final String body;
  final Person to, from;
  final Chat chatGroup;

  Draft(this.body, this.to, this.from, this.chatGroup);

  Message toMessage() {
    var _msg = Message(body, to, from, uuid.v4(), chatGroup);
    print("msg created!");
    print(_msg);
    return _msg;
  }

  @override
  String toString() {
    return '[Draft]\n body: $body \n to?.username : ${to?.username}\n chatgroup.id?: ${chatGroup?.id}';
  }
}
