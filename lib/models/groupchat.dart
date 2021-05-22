import 'chat.dart';

class GroupChat extends Chat {
  final String username;

  GroupChat(this.username, [name = '', photoURL = ''])
      : super(Chat.uuid.v4(), name, photoURL);
}
