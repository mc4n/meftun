import 'package:me_flutting/models/person.dart';

import 'chat.dart';
import 'draft.dart';

class Message extends Draft {
  final String id;
  Message(String body, Person from, this.id, Chat c) : super(body, from, c);

  @override
  set setBody(String body) => throw Exception('message already sent :(');
}

Message simulateMsg(String msgText,
        [bool direction = true, int contactIndex = 0]) =>
    !direction
        ? Message(msgText, contacts[contactIndex], me.id, me)
        : Message(msgText, me, me.id, contacts[contactIndex]);
