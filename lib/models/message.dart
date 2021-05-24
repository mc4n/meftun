import 'package:me_flutting/models/person.dart';
import 'chat.dart';
import 'draft.dart';

class Message extends Draft {
  final String id;
  Message(String body, Person from, this.id, Chat c) : super(body, from, c);

  @override
  set setBody(String body) => throw Exception('message already sent :(');
}

Message _simulateMsg(String msgText,
        [bool direction = true, int contactIndex = 0]) =>
    !direction
        ? Message(msgText, contacts[contactIndex], me.id, me)
        : Message(msgText, me, me.id, contacts[contactIndex]);

final myMessages = [
  _simulateMsg('it is okey', false, 0),
  _simulateMsg('you know.', false),
  _simulateMsg('yeah'),
  _simulateMsg('i know.'),
  _simulateMsg('thanks'),
  _simulateMsg(':)', false),
  _simulateMsg('asd asda adl qwew e \n woe qwoe r53 \n teorterot'),
  _simulateMsg('', false),
  _simulateMsg('are you there?', false, 2),
  _simulateMsg('cooool!', true, 1),
  _simulateMsg(':-)', false, 3),
];
