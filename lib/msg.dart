import 'person.dart';

class Message {
  final String uuid;
  final String body;
  final bool saved;
  final Person from;

  Message({
    this.uuid,
    this.body,
    this.saved,
    this.from,
  });

  get isSaved => this.saved;

  Message copyWith({
    String uuid,
    String body,
    bool saved,
    Person buddy,
  }) {
    return Message(
      uuid: uuid ?? this.uuid,
      body: body ?? this.body,
      saved: saved,
      from: buddy ?? this.from,
    );
  }
}
