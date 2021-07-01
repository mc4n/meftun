import 'dart:io' show File;

Future<void> fileExists(String pth, Future<void> Function(File) ifExists,
    void Function(String) ifNot) async {
  if (pth == null) return ifNot(pth);
  final _file = File(pth);
  if (await _file.exists() && await _file.length() > 0) return ifExists(_file);
  return ifNot(pth);
}
