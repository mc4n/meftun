import 'person.dart';

class Draft {
  final String uuid;
  final String body;
  final Person to;

  Draft({
    this.uuid,
    this.body,
    this.to,
  });

  Draft copyWith({
    String uuid,
    String body,
    Person receipt,
  }) {
    return Draft(
      uuid: uuid ?? this.uuid,
      body: body ?? this.body,
      to: receipt ?? this.to,
    );
  }
}
