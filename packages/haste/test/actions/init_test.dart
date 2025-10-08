import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Init action', () {
    testWidgets('The callback is invoked when the action is initialized', (
      WidgetTester tester,
    ) async {
      int callCount = 0;
      late StateAction<int> state;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state(0);
            actions.init(() {
              callCount++;
            });
            return Container();
          },
        ),
      );

      expect(callCount, 1);

      state.value = 1;

      await tester.pump();

      expect(callCount, 1);
    });
  });
}
