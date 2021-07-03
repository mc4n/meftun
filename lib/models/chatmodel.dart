import 'basemodel.dart';

class ChatModel extends ModelBase {
  final String displayName;
  final String type;
  ChatModel(String id, this.displayName, this.type) : super(id: id);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'display_name': displayName,
        '_type': type,
      };
}

abstract class ChatModelFrom implements ModelFrom<ChatModel> {
  @override
  ChatModel modelFrom(Map<String, dynamic> _map) =>
      ChatModel(_map['id'], _map['display_name'], _map['_type']);
}
