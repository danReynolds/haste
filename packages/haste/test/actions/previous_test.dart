import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Previous action', () {
    testWidgets('A previous action returns the previous built value', (
      WidgetTester tester,
    ) async {
      late int value;
      late int? prevValue;
      late void Function(int) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            (value, updater) = actions.state(0);
            prevValue = actions.previous(value);
            return Container();
          },
        ),
      );

      expect(prevValue, null);
      expect(value, 0);

      updater(1);

      await tester.pump();

      expect(prevValue, 0);
      expect(value, 1);

      updater(5);

      await tester.pump();

      expect(prevValue, 1);
      expect(value, 5);
    });
  });
}
