import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/models/draft.dart';
import 'package:me_flutting/models/person.dart';

void main() async {
  test('testCreateMsg', () {
    var draft = Draft(me, contacts[0]);

    var msg = draft.toMessage();

    expect(msg.id, isNotNull);
  });
}

final Person me = Person("mcan", "Mustafa Can");

final List<Person> contacts = [
  Person('2pac'),
  Person('ali'),
  Person('veli'),
  Person('deli'),
  Person('peri')
];
