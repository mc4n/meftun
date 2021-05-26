import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<FileSystemEntity> fileOpsInTempDir(
    Future<void> Function(Directory dir) action) async {
  var dir = await getDownloadsDirectory();
  var temp = await dir.createTemp();
  await action(temp);
  var fsEnt = await temp.delete();
  return fsEnt;
}
