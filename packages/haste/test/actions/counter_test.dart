import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

class CounterAction extends HasteAction<int> {
  int _count;
  late final Timer _timer;

  CounterAction(this._count, Duration duration) {
    _timer = Timer.periodic(duration, (_) {
      _count++;
      markNeedsBuild();
    });
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CounterActionBuilder extends HasteActionBuilder {
  const CounterActionBuilder();

  int call(int initialValue, Duration duration, {Key? key}) {
    final action = rebuild(key, () => CounterAction(initialValue, duration));
    return action._count;
  }
}

extension HasteCounterAction on Haste {
  CounterActionBuilder get counter => const CounterActionBuilder();
}

void main() {
  group('Counter action', () {
    testWidgets('A counter returns an incrementing value periodically', (
      WidgetTester tester,
    ) async {
      late Key key;
      late int value;
      late void Function(Key) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            (key, updater) = actions.state.init(() => UniqueKey());
            value = actions.counter(0, Duration(milliseconds: 1), key: key);
            return Container();
          },
        ),
      );

      expect(value, 0);

      await tester.pump(Duration(milliseconds: 1));

      expect(value, 1);

      await tester.pump(Duration(milliseconds: 1));

      expect(value, 2);

      // Reset the counter by changing its key.
      updater(UniqueKey());

      await tester.pump(Duration(milliseconds: 1));

      expect(value, 0);

      await tester.pump(Duration(milliseconds: 1));

      expect(value, 1);
    });
  });
}
