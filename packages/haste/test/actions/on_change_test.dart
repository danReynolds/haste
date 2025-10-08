import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('OnChange action', () {
    testWidgets('The callback is invoked when the action key changes', (
      WidgetTester tester,
    ) async {
      int changeCount = 0;
      late StateAction<int> state;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state(0);
            actions.onChange(() {
              changeCount++;
            }, key: ValueKey(state.value));
            return Container();
          },
        ),
      );

      expect(changeCount, 0);

      state.value = 1;

      await tester.pump();

      expect(changeCount, 1);

      state.value = 5;

      await tester.pump();

      expect(changeCount, 2);
    });
  });
}
