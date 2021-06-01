import 'directchat.dart' show DirectChat;
import 'chat.dart' show Chat;
import 'draft.dart' show Draft;

class Message extends Draft {
  final String id;
  final int epoch = DateTime.now().millisecondsSinceEpoch;
  Message(String body, DirectChat from, this.id, Chat c) : super(body, from, c);

  @override
  set setBody(String _) => throw Exception('message already sent :(');

  static int compareEpoch(Message _d1, Message _d2) {
    var ep1 = _d1.epoch;
    var ep2 = _d2.epoch;
    if (ep1 > ep2)
      return 1;
    else if (ep2 > ep1) return -1;
    return 0;
  }

  @override
  String toString() {
    return '[Message]\n id: $id \n body: $body \n';
  }

  @override
  bool operator ==(Object other) => id == ((other is Message) ? other.id : '');

  @override
  int get hashCode => id.hashCode;

  String epochToTimeString() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this.epoch);
    return DateTime.now().difference(dt).toString();
  }
}
