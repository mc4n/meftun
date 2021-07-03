import 'draft.dart' show Draft;
import 'directchat.dart' show DirectChat;
import 'message.dart' show Message;
import 'mbody.dart' show MBody;
import 'package:uuid/uuid.dart';

abstract class Chat {
  static const GROUP = 'G';
  static const DIRECT = 'D';
  static const BOT = 'B';

  static Uuid uuid = Uuid();
  final String id;
  final String displayName;
  final String defaultPhotoURL;
  Chat(this.id, this.displayName, this.defaultPhotoURL);

  static String newId() => Chat.uuid.v4();

  @override
  String toString() {
    return '[Chat]\nid : ${id ?? ""} \n display name: $displayName??""';
  }

  Draft createDraft(DirectChat from, [MBody body]) => Draft(body, from, this);

  Message createMessage(DirectChat from, MBody body) =>
      createDraft(from, body).toMessage();

  String get caption;

  @override
  bool operator ==(Object other) => id == ((other is Chat) ? other.id : '');

  @override
  int get hashCode => id.hashCode;

  String get type;
}
