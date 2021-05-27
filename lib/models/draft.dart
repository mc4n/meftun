import 'dart:math';

import 'package:uuid/uuid.dart';

import 'chat.dart';
import 'message.dart';
import 'directchat.dart';

class Draft {
  static Uuid uuid = Uuid();
  String body;
  final Person from;
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

final Random rnd = Random();

final List<Draft> allDrafts = [
  'lorem',
  'lorem ipsum :D',
  'iyidir',
  'come on!',
  'the world is yours!',
  'moooooo',
  'i love the way you do it',
  'what do you do?'
].map((bd) {
  return Draft(bd, me, contacts[rnd.nextInt(contacts.length)]);
});
