import 'package:me_flutting/models/chat.dart';

class Person extends Chat {
  final String username;

  Person(this.username, [name = '', photoURL = ''])
      : super(Chat.uuid.v4(), name, photoURL);
}
