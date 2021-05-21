import 'package:me_flutting/models/person.dart';

import 'chat.dart';
import 'draft.dart';

class Message extends Draft {
  final String id;
  Message(String body, Person to, Person from, this.id, Chat c)
      : super(body, to, from, c);
}
