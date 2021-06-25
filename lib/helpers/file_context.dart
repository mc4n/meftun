import 'dart:io' show File;
/*, Directory, FileSystemEntity;
import 'package:path_provider/path_provider.dart' show getDownloadsDirectory;

Future<FileSystemEntity> fileOpsInTempDir(
    Future<void> Function(Directory dir) action) async {
  var dir = await getDownloadsDirectory();
  var temp = await dir.createTemp();
  await action(temp);
  var fsEnt = await temp.delete();
  return fsEnt;
}*/

Future<void> fileExists(String pth, Future<void> Function(File) ifExists,
    void Function(String) ifNot) async {
  if (pth == null) return ifNot(pth);
  final _file = File(pth);
  if (await _file.exists() && await _file.length() > 0) return ifExists(_file);
  return ifNot(pth);
}
