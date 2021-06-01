import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:me_flutting/models/message.dart';
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

  Draft createDraft(DirectChat from, [String body]) => Draft(body, from, this);

  Message createMessage(DirectChat from, String body) =>
      createDraft(from, body).toMessage();

  String get caption;

  @override
  bool operator ==(Object other) => id == ((other is Chat) ? other.id : '');

  @override
  int get hashCode => id.hashCode;
}
