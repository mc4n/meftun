import 'package:me_flutting/models/chat.dart';

class Person extends Chat {
  final String username;

  Person(this.username, [name = '', photoURL = ''])
      : super(null, name, photoURL);

  @override
  String toString() {
    return '[User]\nusername : ${username ?? ""} \n name: $name??""';
  }
}
