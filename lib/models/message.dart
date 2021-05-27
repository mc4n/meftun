import 'package:me_flutting/models/directchat.dart';
import 'chat.dart';
import 'draft.dart';

class Message extends Draft {
  final String id;
  Message(String body, DirectChat from, this.id, Chat c) : super(body, from, c);

  @override
  set setBody(String _) => throw Exception('message already sent :(');
}
