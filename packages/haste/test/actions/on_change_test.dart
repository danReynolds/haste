import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';
import '../test_builder.dart';

class Disposable {
  bool disposed = false;

  void dispose() {
    disposed = true;
  }
}

void main() {
  group('OnChange action', () {
    testWidgets('The callback is invoked when the action key changes', (
      WidgetTester tester,
    ) async {
      int changeCount = 0;
      late StateAction<int> state;

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(0);
            context.onChange(() {
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
