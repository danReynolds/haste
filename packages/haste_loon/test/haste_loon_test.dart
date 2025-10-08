import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:haste/haste.dart';
import 'package:haste_loon/haste_loon.dart';
import 'package:loon/loon.dart';
import 'test_builder.dart';

void main() {
  group('Document action', () {
    testWidgets('Updates with the expected values', (
      WidgetTester tester,
    ) async {
      late DocumentSnapshot<int>? value;

      final doc = Loon.collection<int>('users').doc('1');

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            value = context.doc(doc);
            return Container();
          },
        ),
      );

      expect(value, null);

      doc.create(1);

      await tester.pump(Duration.zero);

      expect(value, DocumentSnapshot(doc: doc, data: 1));

      doc.update(2);

      await tester.pump(Duration.zero);

      expect(value, DocumentSnapshot(doc: doc, data: 2));
    });

    testWidgets('A document initializer is called once', (
      WidgetTester tester,
    ) async {
      late StateAction<int> state;
      int initCalls = 0;

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(0);
            context.doc.init(() {
              initCalls++;
              return Loon.collection<int>('users').doc('1');
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);

      state.value = 1;

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('Resets when the document changes', (
      WidgetTester tester,
    ) async {
      late DocumentSnapshot<int>? value;
      late StateAction<Document<int>> state;

      final userDoc = Loon.collection<int>('users').doc('1');
      final userDoc2 = Loon.collection<int>('users').doc('2');

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(userDoc);
            value = context.doc(state.value);
            return Container();
          },
        ),
      );

      expect(value, null);

      userDoc.create(1);

      await tester.pump(Duration.zero);

      expect(value, DocumentSnapshot(doc: userDoc, data: 1));

      state.value = userDoc2;

      await tester.pump(Duration.zero);

      expect(value, null);

      userDoc2.create(2);

      await tester.pump(Duration.zero);

      expect(value, DocumentSnapshot(doc: userDoc2, data: 2));
    });
  });

  group('Query action', () {
    testWidgets('Updates with the expected values', (
      WidgetTester tester,
    ) async {
      late List<DocumentSnapshot<int>> value;

      final collection = Loon.collection<int>('users');
      final userDoc = collection.doc('1');

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            value = context.query(Loon.collection<int>('users'));
            return Container();
          },
        ),
      );

      expect(value, []);

      collection.doc('1').create(1);

      await tester.pump(Duration.zero);

      expect(value, [DocumentSnapshot(doc: userDoc, data: 1)]);

      userDoc.update(2);

      await tester.pump(Duration.zero);

      expect(value, [DocumentSnapshot(doc: userDoc, data: 2)]);
    });

    testWidgets('A query initializer is called once', (
      WidgetTester tester,
    ) async {
      late StateAction<int> state;
      int initCalls = 0;

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(0);
            context.query.init(() {
              initCalls++;
              return Loon.collection<int>('users');
            });
            return Container();
          },
        ),
      );

      expect(initCalls, 1);

      state.value = 1;

      await tester.pump();

      expect(initCalls, 1);
    });

    testWidgets('Resets when the query changes', (WidgetTester tester) async {
      late List<DocumentSnapshot<int>> value;
      late StateAction<Collection<int>> state;

      final users = Loon.collection<int>('users');
      final friends = Loon.collection<int>('friends');

      final userDoc = users.doc('1');
      final friendDoc = friends.doc('1');

      await tester.pumpWidget(
        TestBuilder(
          builder: (context) {
            state = context.state(users);
            value = context.query(state.value);
            return Container();
          },
        ),
      );

      expect(value, []);

      userDoc.create(1);

      await tester.pump(Duration.zero);

      expect(value, [DocumentSnapshot(doc: userDoc, data: 1)]);

      state.value = friends;

      await tester.pump(Duration.zero);

      expect(value, []);

      friendDoc.create(1);

      await tester.pump(Duration.zero);

      expect(value, [DocumentSnapshot(doc: friendDoc, data: 1)]);
    });
  });
}
