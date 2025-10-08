import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haste/haste.dart';

void main() {
  group('Stream action', () {
    testWidgets('Updates with the expected sequence of async snapshots', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;

      final controller = StreamController<int>();

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            snap = actions.stream(controller.stream);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      controller.add(1);

      await tester.pump(Duration.zero);

      expect(snap.connectionState, ConnectionState.active);
      expect(snap.data, 1);

      controller.add(2);

      await tester.pump(Duration.zero);

      expect(snap.connectionState, ConnectionState.active);
      expect(snap.data, 2);

      controller.add(3);

      await tester.pump(Duration.zero);

      expect(snap.connectionState, ConnectionState.active);
      expect(snap.data, 3);

      controller.close();

      await tester.pump(Duration.zero);

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 3);
    });

    testWidgets('A stream initializer is called only once', (
      WidgetTester tester,
    ) async {
      int initCalls = 0;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            actions.stream.init(() {
              initCalls++;
              return Stream.value(2);
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('Immediately provides initial data in the snapshot', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;

      final stream = Stream.value(2);

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            snap = actions.stream(stream, initialData: 0);
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

      final controller = StreamController<int>();

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            snap = actions.stream(controller.stream);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      controller.add(1);

      await tester.pump(Duration.zero);

      expect(snap.connectionState, ConnectionState.active);
      expect(snap.data, 1);

      controller.addError('test');

      await tester.pump(Duration.zero);

      expect(snap.connectionState, ConnectionState.active);
      expect(snap.hasError, true);
      expect(snap.error, 'test');

      controller.add(2);

      await tester.pump(Duration.zero);

      // The stream remains active and can receive data after an error.
      expect(snap.connectionState, ConnectionState.active);
      expect(snap.hasError, false);
      expect(snap.data, 2);
    });

    testWidgets('Resets when the stream changes', (WidgetTester tester) async {
      late AsyncSnapshot<int> snap;
      late StateAction<Stream<int>> state;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state.init(() => Stream.value(2));
            snap = actions.stream(state.value);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 2);

      state.value = Stream.value(3);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 3);
    });

    testWidgets('Does not deliver old stream values', (
      WidgetTester tester,
    ) async {
      late AsyncSnapshot<int> snap;
      late StateAction<Stream<int>> state;

      await tester.pumpWidget(
        HasteBuilder(
          builder: (context, actions) {
            state = actions.state.init(
              () => Stream.fromFuture(
                Future.delayed(Duration(milliseconds: 100), () => 2),
              ),
            );
            snap = actions.stream(state.value);
            return Container();
          },
        ),
      );

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      await tester.pump();

      // There is no value yet since the stream is delayed.
      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      state.value = Stream.value(3);

      await tester.pump();

      expect(snap.connectionState, ConnectionState.none);
      expect(snap.data, null);

      // The original stream has emitted its value by this time, but its snapshot should never be delivered since the underlying stream has changed.
      await tester.pump(Duration(milliseconds: 100));

      expect(snap.connectionState, ConnectionState.done);
      expect(snap.data, 3);
    });
  });
}
