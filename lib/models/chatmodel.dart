import 'basemodel.dart';

class ChatModel implements ModelBase {
  final String id;
  final String userName;
  final String name;
  final String photoURL;
  final String type;
  const ChatModel(this.id, this.userName, this.name, this.photoURL, this.type);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'user_name': userName,
        'name': name,
        'photo_url': photoURL,
        '_type': type,
      };
}

abstract class ChatModelFrom implements ModelFrom<ChatModel> {
  @override
  ChatModel modelFrom(Map<String, dynamic> _map) => ChatModel(_map['id'],
      _map['user_name'], _map['name'], _map['photo_url'], _map['_type']);
}
