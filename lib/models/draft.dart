import 'package:uuid/uuid.dart';

import 'message.dart';
import 'person.dart';

class Draft {
  static Uuid uuid = Uuid();
  final String body;
  final Person to, from;

  Draft(this.body, this.to, this.from);

  Message toMessage() {
    var _msg = Message(body, to, from, uuid.v4());
    print("msg created!");
    print(_msg);
    return _msg;
  }
}
