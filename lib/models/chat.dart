import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/message.dart';
import 'package:me_flutting/models/person.dart';
import 'package:uuid/uuid.dart';

abstract class Chat {
  static Uuid uuid = Uuid();
  final String id;
  final String name;
  final String photoURL;
  Chat(this.id, this.name, this.photoURL);

  @override
  String toString() {
    return '[Chat]\nid : ${id ?? ""} \n name: $name??""';
  }

  Draft createDraft(Person from) {
    return Draft(null, from, this);
  }

  String get caption;

  Iterable<Message> getMessages() {
    var recv = (Message element) =>
        element.from.id == this.id && element.chatGroup.id == me.id;
    var sent = (Message element) =>
        element.from.id == me.id && element.chatGroup.id == this.id;
    return myMessages.where((element) => recv(element) || sent(element));
  }

  Message getLastMessage() {
    try {
      return getMessages()?.last;
    } catch (e) {
      return Draft('', me, this).toMessage();
    }
  }
}
