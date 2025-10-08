import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  testWidgets("Successive actions are disposed when an action's type changes", (
    WidgetTester tester,
  ) async {
    bool disposed = false;

    late void Function(bool) flagUpdater;
    late void Function(int) countUpdater;

    late int count;

    await tester.pumpWidget(
      HasteBuilder(
        builder: (context, actions) {
          final (flag, setFlag) = actions.state(false);
          flagUpdater = setFlag;

          // Changing the value of state will alter the action type of the action at this index,
          // triggering a disposal of all successive actions.
          if (flag) {
            actions.init(() => {});
          } else {
            actions.memo(() => 0);
          }

          (count, countUpdater) = actions.state(0);
          actions.dispose(() => disposed = true);

          return Container();
        },
      ),
    );

    expect(disposed, false);
    expect(count, 0);

    countUpdater(1);

    await tester.pump();

    expect(disposed, false);
    expect(count, 1);

    // Updating this flag invalidates all successive actions.
    flagUpdater(true);

    await tester.pump();

    // The subsequent state and dispose actions should now have been disposed and reinitialized.
    expect(disposed, true);
    expect(count, 0);
  });

  testWidgets("Successive actions are preserved when an action's key changes", (
    WidgetTester tester,
  ) async {
    bool disposed = false;

    late Key key;
    late int count;
    late int count2;
    late void Function(Key) keyUpdater;
    late void Function(int) countUpdater;
    late void Function(int) countUpdater2;

    await tester.pumpWidget(
      HasteBuilder(
        builder: (context, actions) {
          (key, keyUpdater) = actions.state.init(() => UniqueKey());
          (count, countUpdater) = actions.state(0, key: key);
          (count2, countUpdater2) = actions.state(0);

          actions.dispose(() => disposed = true);

          return Container();
        },
      ),
    );

    expect(count, 0);
    expect(count2, 0);
    expect(disposed, false);

    countUpdater(1);
    countUpdater2(1);

    await tester.pump();

    expect(count, 1);
    expect(count2, 1);
    expect(disposed, false);

    keyUpdater(UniqueKey());

    await tester.pump();

    // Changing the key of the first state invalidates the key of state2, which causes state2 to be reinitialized
    // but should not dispose or reinitialize state3 and the subsequent dispose action.
    expect(count, 0);
    expect(count2, 1);
    expect(disposed, false);
  });
}
