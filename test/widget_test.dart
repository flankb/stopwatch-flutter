// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_appbar/metro_appbar.dart';

import 'package:stopwatch/widgets/circular.dart';

void main() {
  //MeasureBloc measureBloc;

  setUp(() async {
    //measureBloc = MeasureBloc(Ticker3(), StopwatchRepository());
    //setupLocators();
    //await PrefService.init(prefix: 'pref_'); // Настройки
  });

  tearDown(() {
    //measureBloc.close();
  });

  testWidgets('Widget test', (WidgetTester tester) async {
    final metroAppBar = MetroAppBar(
      primaryCommands: <Widget>[
        PrimaryCommand(onPressed: () {}, icon: Icons.comment, text: 'Test')
      ],
      secondaryCommands: <SecondaryCommand>[
        SecondaryCommand(text: 'about', onPressed: () {})
      ],
    );

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(CenterCircularWidget());

    final messageFinder = find.text('M');
    expect(messageFinder, findsNothing);
  });
}
