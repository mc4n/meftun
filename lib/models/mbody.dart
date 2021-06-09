import 'draft.dart' show Draft;
import 'directchat.dart' show DirectChat;
import 'chat.dart' show Chat;

abstract class MBody {
  static const RAW_MESSAGE = 'R';
  static const JSON_MESSAGE = 'J';
  static const FILE_MESSAGE = 'F';
  static const IMAGE_MESSAGE = 'I';
  String get bodyType;
}

class RawBody extends MBody {
  String _rawString;
  RawBody(this._rawString);
  String get bodyType => MBody.RAW_MESSAGE;

  @override
  String toString() => _rawString ?? '<NULL>';
}

class JsonBody extends RawBody {
  JsonBody(String json) : super(json);
  String get bodyType => MBody.JSON_MESSAGE;
  String get json => _rawString;
}

class FileBody extends RawBody {
  final String _filePath;
  FileBody(this._filePath, [String description]) : super(description);
  String get bodyType => MBody.FILE_MESSAGE;
  String get filePath => _filePath;
  String get description => _rawString;
  @override
  String toString() => _filePath ?? '<NO-PATH>';
}

class ImageBody extends FileBody {
  ImageBody(String imagePath, [String description])
      : super(imagePath, description);
  String get bodyType => MBody.IMAGE_MESSAGE;
}

void main() {
  final msg = Draft(ImageBody('/wwewe/rgerge.jpg', 'rgerge is a biiiatch'),
          DirectChat(Chat.newId(), 'from'), DirectChat(Chat.newId(), 'to'))
      .toMessage();
  print(msg);
}
