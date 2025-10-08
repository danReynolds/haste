import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('State action', () {
    testWidgets('Rebuilds with the updated state value when changed', (
      WidgetTester tester,
    ) async {
      late int value;
      late void Function(int) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            (value, updater) = actions.state(0);
            return Container();
          },
        ),
      );

      expect(value, 0);

      updater(1);

      await tester.pump();

      expect(value, 1);
    });

    testWidgets('A memoized initializer is called once', (
      WidgetTester tester,
    ) async {
      late void Function(int) updater;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            (_, updater) = actions.state.init(() {
              initCalls++;
              return 0;
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);

      updater(1);

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('State is reinitialized on key changes', (
      WidgetTester tester,
    ) async {
      late Key? key;
      late void Function(Key?) keyUpdater;

      late int value;
      late void Function(int) valueUpdater;

      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            (key, keyUpdater) = actions.state<Key?>(null);

            (value, valueUpdater) = actions.state.init(() {
              initCalls++;
              return 0;
            }, key: key);

            return Container();
          },
        ),
      );

      expect(value, 0);
      expect(initCalls, 1);

      valueUpdater(1);

      await tester.pump();

      expect(value, 1);
      expect(initCalls, 1);

      keyUpdater(UniqueKey());

      await tester.pump();

      expect(initCalls, 2);
      expect(value, 0);
    });
  });
}
