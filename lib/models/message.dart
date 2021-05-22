import 'package:me_flutting/models/person.dart';

import 'chat.dart';
import 'draft.dart';

class Message extends Draft {
  final String id;
  Message(String body, Person from, this.id, Chat c) : super(from, c);

  @override
  set setBody(String body) => throw Exception('message already sent :(');
}
