import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('testFileOps', () async {
    var dir = getApplicationDocumentsDirectory();

    expect(dir, isNotNull);
  });
}
