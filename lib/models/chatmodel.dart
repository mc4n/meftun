import 'basemodel.dart';

class ChatModel extends ModelBase<String> {
  final String displayName;
  final String type;
  ChatModel(String id, this.displayName, this.type) : super(id: id);

  @override
  Map<String, dynamic> get map => {
        'display_name': displayName,
        '_type': type,
      };
}

abstract class ChatModelFrom implements ModelFrom<ChatModel, String> {
  @override
  ChatModel modelFrom(String _key, Map<String, dynamic> _map) =>
      ChatModel(_key, _map['display_name'], _map['_type']);
}
