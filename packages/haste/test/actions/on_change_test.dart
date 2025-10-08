import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('OnChange action', () {
    testWidgets('The callback is invoked when the action key changes', (
      WidgetTester tester,
    ) async {
      int changeCount = 0;
      late void Function(int) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (count, setCount) = actions.state(0);
            updater = setCount;
            actions.onChange(() {
              changeCount++;
            }, key: ValueKey(count));
            return Container();
          },
        ),
      );

      expect(changeCount, 0);

      updater(1);

      await tester.pump();

      expect(changeCount, 1);

      updater(5);

      await tester.pump();

      expect(changeCount, 2);
    });
  });
}
