import 'directchat.dart' show DirectChat;
import 'chat.dart' show Chat;
import 'draft.dart' show Draft;
import 'mbody.dart' show MBody;

class Message extends Draft {
  static const CHARACTER_LIMIT = 50000;
  final String id;
  final int epoch;
  Message(this.id, MBody body, DirectChat from, Chat group, this.epoch)
      : super(body, from, group) {
    if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(epoch))
            .inDays <
        -1) {
      throw new Exception('ERROR: A future date is invalid for a message!');
    }
  }

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
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch);
    final ts = DateTime.now().difference(dt);
    final _fmtt = (int _) {
      var _str = _.toString();
      if (_str.length == 1) return _str = '0$_str';
      return _str;
    };
    final fmtFullDate = (DateTime _dt) => '${_dt.day}/${_dt.month}/${_dt.year}';
    final dayDiff = ts.inDays;
    return dayDiff > 1
        ? fmtFullDate(dt)
        : '${_fmtt(dt.hour)}:${_fmtt(dt.minute)}';
  }
}
