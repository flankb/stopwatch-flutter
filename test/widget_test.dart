// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preferences.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';

import 'package:stopwatch/main.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/service_locator.dart';
import 'package:stopwatch/util/ticker.dart';
import 'package:stopwatch/widgets/buttons_bar.dart';
import 'package:stopwatch/widgets/circular.dart';
import 'package:stopwatch/widgets/metro_app_bar.dart';
import 'package:stopwatch/widgets/stopwatch_body.dart';

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
    final metroAppBar = MetroAppBar(primaryCommands: <Widget>[
        PrimaryCommand(onPressed: (){}, pic: Icons.comment, tooltip: 'Test')
    ], secondaryCommands: <SecondaryCommand>[
      SecondaryCommand(commandName: 'about', onPressed: () {}, child: Text('Hello'))
    ],
    );

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(CenterCircularWidget());

    final messageFinder = find.text('M');
    expect(messageFinder, findsNothing);
  });
}
