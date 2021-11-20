import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Run test instrumented', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final textFinder = find.byValueKey('overall_text');
    final buttonFinder = find.byValueKey('start_button');

    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.close();
    });

    test('Start test', () async {
      // First, tap the button.
      await driver.tap(buttonFinder);

      await Future<void>.delayed(const Duration(milliseconds: 1000));

      // Then, verify the counter text is incremented by 1.
      expect((await driver.getText(textFinder)).contains('1'), true);
    });
  });
}
