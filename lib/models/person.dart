import 'package:me_flutting/models/chat.dart';

class Person extends Chat {
  final String username;

  Person(this.username, [name = '', photoURL = ''])
      : super(Chat.uuid.v4(), name, photoURL);

  @override
  String get caption => username;
}

final Person me = Person("mcan", "Mustafa Can");
const ITEM_C = 5;
final List<Person> contacts = [
  Person('2pac'),
  Person('ali'),
  Person('veli'),
  Person('deli'),
  Person('peri')
];
