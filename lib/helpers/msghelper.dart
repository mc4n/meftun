import 'dart:math';

import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/message.dart';

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
  _simulateMsg('are you there?', false, 2),
  _simulateMsg('cooool!', true, 1),
  _simulateMsg(':-)', false, 3),
];

Iterable<Message> getMessages(Chat chat) {
  var recv = (Message element) =>
      element.from.id == chat.id && element.chatGroup.id == me.id;
  var sent = (Message element) =>
      element.from.id == me.id && element.chatGroup.id == chat.id;
  return myMessages.where((element) => recv(element) || sent(element));
}

Message getLastMessage(Chat chat) {
  try {
    return getMessages(chat)?.last;
  } catch (e) {
    return Draft('', me, chat).toMessage();
  }
}

final DirectChat me = DirectChat("mcan", "Mustafa Can");
const ITEM_C = 5;
final List<DirectChat> contacts = [
  DirectChat('2pac'),
  DirectChat('ali'),
  DirectChat('veli'),
  DirectChat('deli'),
  DirectChat('peri')
];

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
