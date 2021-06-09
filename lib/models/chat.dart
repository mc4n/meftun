import 'draft.dart' show Draft;
import 'directchat.dart' show DirectChat;
import 'message.dart' show Message;
import 'mbody.dart' show MBody;
import 'package:uuid/uuid.dart';

abstract class Chat {
  static Uuid uuid = Uuid();
  final String id;
  final String name;
  final String photoURL;
  Chat(this.id, this.name, this.photoURL);

  static String newId() => Chat.uuid.v4();

  @override
  String toString() {
    return '[Chat]\nid : ${id ?? ""} \n name: $name??""';
  }

  Draft createDraft(DirectChat from, [MBody body]) => Draft(body, from, this);

  Message createMessage(DirectChat from, MBody body) =>
      createDraft(from, body).toMessage();

  String get caption;

  @override
  bool operator ==(Object other) => id == ((other is Chat) ? other.id : '');

  @override
  int get hashCode => id.hashCode;

  ChatTypes get type;
}

enum ChatTypes {
  Direct,
  Group,
  Bot,
}
