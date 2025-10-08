import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  testWidgets("Successive actions are disposed when an action's type changes", (
    WidgetTester tester,
  ) async {
    bool disposed = false;
    late StateAction<bool> state;
    late StateAction<int> state2;

    late int value2;

    await tester.pumpWidget(
      HasteBuilder(
        builder: (context, actions) {
          state = actions.state(false);

          // Changing the value of state will alter the action type of the action at this index,
          // triggering a disposal of all successive actions.
          if (state.value) {
            actions.init(() => {});
          } else {
            actions.memo(() => 0);
          }

          state2 = actions.state(0);
          value2 = state2.value;
          actions.dispose(() => disposed = true);

          return Container();
        },
      ),
    );

    expect(disposed, false);
    expect(value2, 0);

    state2.value = 1;

    await tester.pump();

    expect(disposed, false);
    expect(value2, 1);

    // Updating this state invalidates all successive actions.
    state.value = true;

    await tester.pump();

    // The subsequent state and dispose actions should now have been disposed and reinitialized.
    expect(disposed, true);
    expect(value2, 0);
  });

  testWidgets("Successive actions are preserved when an action's key changes", (
    WidgetTester tester,
  ) async {
    bool disposed = false;

    late StateAction<Key> state;
    late StateAction<int> state2;
    late StateAction<int> state3;

    late int value2;
    late int value3;

    await tester.pumpWidget(
      HasteBuilder(
        builder: (context, actions) {
          state = actions.state.init(() => UniqueKey());
          state2 = actions.state(0, key: state.value);
          state3 = actions.state(0);

          value2 = state2.value;
          value3 = state3.value;

          actions.dispose(() => disposed = true);

          return Container();
        },
      ),
    );

    expect(value2, 0);
    expect(value3, 0);
    expect(disposed, false);

    state2.value = 1;
    state3.value = 1;

    await tester.pump();

    expect(value2, 1);
    expect(value3, 1);
    expect(disposed, false);

    state.value = UniqueKey();

    await tester.pump();

    // Changing the key of the first state invalidates the key of state2, which causes state2 to be reinitialized
    // but should not dispose or reinitialize state3 and the subsequent dispose action.
    expect(value2, 0);
    expect(value3, 1);
    expect(disposed, false);
  });
}
