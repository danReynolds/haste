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
  group('Dispose action', () {
    testWidgets('A dispose action is called once on dispose', (
      WidgetTester tester,
    ) async {
      bool disposed = false;
      late StateAction<int> state;

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(0);
            context.dispose(() => disposed = true);
            return Container();
          },
        ),
      );

      expect(disposed, false);

      state.value = 1;

      await tester.pump();

      expect(disposed, false);

      await tester.pumpWidget(Container());

      expect(disposed, true);
    });

    testWidgets('Calls the dispose function from the latest rebuild', (
      WidgetTester tester,
    ) async {
      Disposable disposable1 = Disposable();
      Disposable disposable2 = Disposable();

      late StateAction<Disposable> state;

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(disposable1);
            context.dispose(() => state.value.dispose());
            return Container();
          },
        ),
      );

      expect(disposable1.disposed, false);
      expect(disposable2.disposed, false);

      state.value = disposable2;

      await tester.pump();

      expect(disposable1.disposed, false);
      expect(disposable2.disposed, false);

      await tester.pumpWidget(Container());

      expect(disposable1.disposed, false);
      expect(disposable2.disposed, true);
    });
  });
}
