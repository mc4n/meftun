import 'basemodel.dart';

class ChatModel implements ModelBase {
  final String id;
  final String displayName;
  final String photoURL;
  final String type;
  const ChatModel(this.id, this.displayName, this.photoURL, this.type);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'display_name': displayName,
        'photo_url': photoURL,
        '_type': type,
      };
}

abstract class ChatModelFrom implements ModelFrom<ChatModel> {
  @override
  ChatModel modelFrom(Map<String, dynamic> _map) => ChatModel(
      _map['id'], _map['display_name'], _map['photo_url'], _map['_type']);
}
