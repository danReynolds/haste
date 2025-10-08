import 'package:computables/computables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:haste/haste.dart';
import 'package:haste_computables/haste_computables.dart';

void main() {
  group('Computable action', () {
    testWidgets('Updates with the expected values', (
      WidgetTester tester,
    ) async {
      late int value;

      final computable = Computable(1);

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            value = actions.compute(computable);
            return Container();
          },
        ),
      );

      expect(value, 1);

      computable.add(2);

      await tester.pump(Duration.zero);

      expect(value, 2);

      computable.add(3);

      await tester.pump(Duration.zero);

      expect(value, 3);
    });

    testWidgets('A computable initializer is called once', (
      WidgetTester tester,
    ) async {
      late StateAction<int> state;
      late int value;
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state(0);
            value = actions.compute.init(() {
              initCalls++;
              return Computable(1);
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);
      expect(value, 1);

      state.value = 1;

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('Resets when the computable changes', (
      WidgetTester tester,
    ) async {
      late int value;
      late StateAction<Computable<int>> state;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state.init(() => Computable(1));
            value = actions.compute(state.value);
            return Container();
          },
        ),
      );

      expect(value, 1);

      state.value = Computable(3);

      await tester.pump();

      expect(value, 3);
    });
  });
}
