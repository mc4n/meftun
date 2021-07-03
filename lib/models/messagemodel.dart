import 'basemodel.dart';

class MessageModel extends ModelBase {
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  final String mbodyType;
  MessageModel(String id, this.body, this.fromId, this.chatGroupId, this.epoch,
      this.mbodyType)
      : super(id: id);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
        'mbody_type': mbodyType,
      };
}

abstract class MessageModelFrom implements ModelFrom<MessageModel> {
  @override
  MessageModel modelFrom(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
      _map['mbody_type'],
    );
  }
}
