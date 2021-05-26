import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:me_flutting/helpers/filehelpers.dart';

void main() {
  test('testFileTempDir', () async {
    var fsEnt = await fileOpsInTempDir((temp) async {
      print('dir: ${temp.path} created.');

      //brda $temp ile biseler yap
      var f = File('${temp.path}/new_file.txt');

      f.writeAsStringSync('hello world!');

      f.deleteSync();

      expect(temp, isNotNull);
    });
    var isNotDeleted = await fsEnt.exists();
    expect(isNotDeleted, false);
    print(fsEnt.path + '> temp deleted succesfully');
  });
}
