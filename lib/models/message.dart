import 'directchat.dart' show DirectChat;
import 'chat.dart' show Chat;
import 'draft.dart' show Draft;
import 'mbody.dart' show MBody;

class Message extends Draft {
  final String id;
  final int epoch;
  Message(this.id, MBody body, DirectChat from, Chat group, this.epoch)
      : super(body, from, group);

  @override
  set setBody(MBody _) => throw Exception('message already sent :(');

  static int compareEpoch(Message _d1, Message _d2) {
    var ep1 = _d1.epoch;
    var ep2 = _d2.epoch;
    if (ep1 > ep2)
      return 1;
    else if (ep2 > ep1) return -1;
    return 0;
  }

  @override
  String toString() => '[Message]\n id: $id \n body: $body \n';

  @override
  bool operator ==(Object other) => id == ((other is Message) ? other.id : '');

  @override
  int get hashCode => id.hashCode;

  String epochToTimeString() {
    final dt = DateTime.fromMillisecondsSinceEpoch(this.epoch);

    final ts = DateTime.now().difference(dt);

    return ts.inDays > 1 || ts.inDays < -1
        ? '${dt.day}/${dt.month}/${dt.year}'
        : '${dt.hour}:${dt.minute}';
  }
}
//  epoch = DateTime.now().millisecondsSinceEpoch;
