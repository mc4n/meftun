import 'package:uuid/uuid.dart';

class Chat {
  static Uuid uuid = Uuid();
  final Uuid id;
  final String name;
  final String photoURL;

  Chat(this.id, this.name, this.photoURL);
}
