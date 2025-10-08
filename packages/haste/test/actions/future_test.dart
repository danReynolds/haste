import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Future action', () {
    testWidgets('Updates with the expected sequence of async snapshots', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;

      final future = Future.value(2);

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            snap = actions.future(future);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 2);
    });

    testWidgets('A future initializer is called only once', (
      WidgetTester tester,
    ) async {
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            actions.future.init(() {
              initCalls++;
              return Future.value(2);
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets(
      'Updates with the expected sequence of async snapshots when using an initializer',
      (WidgetTester tester) async {
        late AsyncSnapshot<int> future;
        int initCalls = 0;

        await tester.pumpWidget(
          HasteBuilder(
            builder: (context, actions) {
              future = actions.future.init(() {
                initCalls++;
                return Future.value(2);
              });
              return Container();
            },
          ),
        );

        expect(initCalls, 1);
        expect(future.connectionState, ConnectionState.none);
        expect(future.data, null);

        await tester.pump();

        expect(initCalls, 1);
        expect(future.connectionState, ConnectionState.done);
        expect(future.data, 2);
      },
    );

    testWidgets('Immediately provides initial data in the snapshot', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;

      final future = Future.value(2);

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            snap = actions.future(future, initialData: 0);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, 0);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 2);
    });

    testWidgets('Updates the snapshot with an error', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;
      final future = Future.sync(() async {
        await Future.delayed(Duration(milliseconds: 10));
        throw 'test';
      });

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            snap = actions.future(future);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump(Duration(milliseconds: 50));

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.hasError, true);
      expect(snap.error, 'test');
    });

    testWidgets('Resets when the future changes', (WidgetTester tester) async {
      late AsyncSnapshot<int> snap;
      late void Function(Future<int>) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (future, setFuture) = actions.state.init(
              () => Future.value(2),
            );
            updater = setFuture;
            snap = actions.future(future);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 2);

      updater(Future.value(3));

      await tester.pump();

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 3);
    });

    testWidgets('Does not deliver old future values', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;
      late void Function(Future<int>) updater;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            final (future, setFuture) = actions.state.init(
              () => Future.delayed(Duration(milliseconds: 100), () => 2),
            );
            updater = setFuture;
            snap = actions.future(future);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      // There is no value yet since the future is delayed.
      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      updater(Future.value(3));

      await tester.pump();

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      // The original future has completed by this time, but its snapshot value should never be delivered since the future has changed.
      await tester.pump(Duration(milliseconds: 100));

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 3);
    });
  });
}
