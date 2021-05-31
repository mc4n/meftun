import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/groupchat.dart';
import 'package:me_flutting/models/message.dart';

class MessageFactory {
  Map<Chat, List<Message>> _items = Map();
  final DirectChat _owner;
  MessageFactory(this._owner) {
    addContact(owner);
  }

  DirectChat get owner => _owner;

  Iterable<Message> getMessages(Chat target) {
    var list =
        _items[target].where((element) => element is Message).toList() ?? [];
    var twoo = (_items[owner].where((element) => element is Message) ?? [])
        .where((element) => element.from == target)
        .toList();
    list.addAll(twoo);
    list.sort((_d1, _d2) {
      // comparison
      var ep1 = _d1.epoch;
      var ep2 = _d2.epoch;
      if (ep1 > ep2)
        return 1;
      else if (ep2 > ep1) return -1;
      return 0;
    });
    return list;
  }

  static Random rnd = Random();

  Message getLastMessage(Chat target) =>
      getMessages(target).lastWhere((element) => true,
          orElse: () => target.createDraft(_owner).toMessage());

  Iterable<Chat> get contacts =>
      _items.keys.where((element) => element != owner);

  void sendMessage(Chat target, String body) =>
      receiveMessage(owner, target, body);

  void receiveMessage(DirectChat from, Chat target, String body) {
    var dr = target.createDraft(from);
    dr.setBody = body;
    _items[target].add(dr.toMessage());

    //
    var responBod = (String bd) {
      List<String> chs = [];

      for (int i = 0; i < bd.length; i++) {
        chs.add(bd[i]);
      }
      chs.shuffle();
      return chs.join(); //'len: ${body.length.toString()}';
    };

    if (target is DirectChat) {
      var num = rnd.nextInt(2);
      if (num == 1) {
        DirectChat trDirc = target;
        receiveMessage(trDirc, from, responBod(body));
      }
    } else {
      var ls = contacts
          .where((i) => i is DirectChat)
          .map((i) => i as DirectChat)
          .toList();
      var num = rnd.nextInt(ls.length * 2);
      if (num != 0 && num < ls.length) {
        Future.delayed(
            Duration(milliseconds: 1500 + rnd.nextInt(5) * 100), () => null);
        receiveMessage(ls[num], target, responBod(body));
      }
    }
  }

  void addContact(Chat target) {
    _items.putIfAbsent(target, () => [target.createDraft(owner).toMessage()]);
  }

  DirectChat addPerson(String userName) {
    var buddy = DirectChat(userName);
    addContact(buddy);
    return buddy;
  }

  GroupChat addGroup(String name) {
    var gro = GroupChat(name);
    addContact(gro);
    return gro;
  }
}
