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

  Message getLastMessage(Chat target) =>
      getMessages(target).lastWhere((element) => true,
          orElse: () => target.createDraft(_owner).toMessage());

  Iterable<Chat> get contacts =>
      _items.keys.where((element) => element != owner);

  void sendMessage(Chat target, String body) =>
      receiveMessage(owner, target, body);

  void receiveMessage(DirectChat from, Chat target, String body) {
    void func(DirectChat _from, Chat _target, String _body) {
      final _dr = target.createDraft(_from);
      _dr.setBody = _body;
      _items[_target].add(_dr.toMessage());
    }

    func(from, target, body);
    // simulate a quick responding----
    if (true) {
      final responBod = (String bd) {
        final List<String> chs = [];
        for (int i = 0; i < bd.length; i++) chs.add(bd[i]);
        chs.shuffle();
        return chs.join();
      };

      if (target is DirectChat) {
        if (body.length * DateTime.now().millisecond % 2 == 1)
          func(target, from, responBod(body));
      } else {
        final ls = contacts
            .where((i) => i is DirectChat)
            .map((i) => i as DirectChat)
            .toList();
        final chanceNum =
            (body.length * DateTime.now().millisecond) % (ls.length * 2);
        if (chanceNum < ls.length) func(ls[chanceNum], target, responBod(body));
      }
    }
    // ----------
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
