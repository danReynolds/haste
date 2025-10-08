import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Memo action', () {
    testWidgets('A memoized initializer is called once', (
      WidgetTester tester,
    ) async {
      late void Function(int) updater;
      late int value;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (count, setCount) = actions.state(0);
            updater = setCount;
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

      updater(1);

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('Memo is reinitialized on key changes', (
      WidgetTester tester,
    ) async {
      late void Function(Key?) updater;
      late int memo;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (key, setKey) = actions.state<Key?>(null);
            updater = setKey;
            memo = actions.memo(() {
              return ++initCalls;
            }, key: key);

            return Container();
          },
        ),
      );

      expect(memo, 1);
      expect(initCalls, 1);

      updater(UniqueKey());

      await tester.pump();

      expect(memo, 2);
      expect(initCalls, 2);
    });
  });
}
