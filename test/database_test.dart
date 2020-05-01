import 'package:flutter_test/flutter_test.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiTestInit();

  group('database tests', () {

    setUp(() async {
    });

    tearDown(() async {
    });

    test('Insert and check category', () async {
    });
  });
}