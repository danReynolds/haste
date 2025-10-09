import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

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
      late void Function(int) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            (_, updater) = actions.state(0);
            actions.dispose(() => disposed = true);
            return Container();
          },
        ),
      );

      expect(disposed, false);

      updater(1);

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

      late void Function(Disposable) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (disposable, setDisposable) = actions.state(disposable1);
            updater = setDisposable;
            actions.dispose(() => disposable.dispose());
            return Container();
          },
        ),
      );

      expect(disposable1.disposed, false);
      expect(disposable2.disposed, false);

      updater(disposable2);

      await tester.pump();

      expect(disposable1.disposed, false);
      expect(disposable2.disposed, false);

      await tester.pumpWidget(Container());

      expect(disposable1.disposed, false);
      expect(disposable2.disposed, true);
    });
  });
}
