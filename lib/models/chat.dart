import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/directchat.dart';
import 'package:uuid/uuid.dart';

abstract class Chat {
  static Uuid uuid = Uuid();
  final String id;
  final String name;
  final String photoURL;
  Chat(this.id, this.name, [this.photoURL= 'avatar.png']);

  @override
  String toString() {
    return '[Chat]\nid : ${id ?? ""} \n name: $name??""';
  }

  Draft createDraft(DirectChat from) {
    return Draft(null, from, this);
  }

  String get caption;
}
