import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Memo action', () {
    testWidgets('A memoized initializer is called once', (
      WidgetTester tester,
    ) async {
      late StateAction<int> state;
      late int value;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state(0);
            value = actions.memo(() {
              initCalls++;
              return 0;
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);
      expect(value, 0);

      state.value = 1;

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('Memo is reinitialized on key changes', (
      WidgetTester tester,
    ) async {
      late StateAction<Key?> key;
      late int memo;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            key = actions.state(null);
            memo = actions.memo(() {
              return ++initCalls;
            }, key: key.value);

            return Container();
          },
        ),
      );

      expect(memo, 1);
      expect(initCalls, 1);

      key.value = UniqueKey();

      await tester.pump();

      expect(memo, 2);
      expect(initCalls, 2);
    });
  });
}
