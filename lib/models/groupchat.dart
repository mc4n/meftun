import 'package:me_flutting/models/person.dart';

import 'chat.dart';

class GroupChat extends Chat {
  GroupChat(name, [photoPath = '']) : super(Chat.uuid.v4(), name, photoPath);

  @override
  String toTitle() => name;
}
