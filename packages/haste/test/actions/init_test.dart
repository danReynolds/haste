import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Init action', () {
    testWidgets('The callback is invoked when the action is initialized', (
      WidgetTester tester,
    ) async {
      int callCount = 0;
      late void Function(int) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (count, setCount) = actions.state(0);
            updater = setCount;
            actions.init(() {
              callCount++;
            });
            return Container();
          },
        ),
      );

      expect(callCount, 1);

      updater(1);

      await tester.pump();

      expect(callCount, 1);
    });
  });
}
