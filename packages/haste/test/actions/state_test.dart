import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('State action', () {
    testWidgets('Rebuilds with the updated state value when changed', (
      WidgetTester tester,
    ) async {
      late int value;
      late StateAction<int> state;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state(0);
            value = state.value;
            return Container();
          },
        ),
      );

      expect(value, 0);

      state.value = 1;

      await tester.pump();

      expect(value, 1);
    });

    testWidgets('A memoized initializer is called once', (
      WidgetTester tester,
    ) async {
      late StateAction<int> state;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state.init(() {
              initCalls++;
              return 0;
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);

      state.value = 1;

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('State is reinitialized on key changes', (
      WidgetTester tester,
    ) async {
      late StateAction<Key?> key;
      late StateAction<int> state;

      late int value;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            key = actions.state(null);

            state = actions.state.init(() {
              initCalls++;
              return 0;
            }, key: key.value);
            value = state.value;

            return Container();
          },
        ),
      );

      expect(value, 0);
      expect(initCalls, 1);

      state.value = 1;

      await tester.pump();

      expect(value, 1);
      expect(initCalls, 1);

      key.value = UniqueKey();

      await tester.pump();

      expect(initCalls, 2);
      expect(value, 0);
    });
  });
}
