import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/person.dart';
import 'package:uuid/uuid.dart';

class Chat {
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
    return Draft(from, this);
  }
}
