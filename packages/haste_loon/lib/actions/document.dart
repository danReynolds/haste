import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haste/haste.dart';
import 'package:loon/loon.dart';

class LoonDocumentAction<T> extends HasteAction {
  final Document<T> _doc;
  late final StreamSubscription<DocumentSnapshot<T>?> _subscription;

  LoonDocumentAction(this._doc) {
    _subscription = _doc.stream().listen((snap) {
      markNeedsBuild();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class LoonDocumentActionBuilder extends HasteActionBuilder {
  DocumentSnapshot<T>? init<T>(Document<T> Function() initializer, {Key? key}) {
    return rebuild(key, () => LoonDocumentAction(initializer()))._doc.get();
  }

  DocumentSnapshot<T>? call<T>(Document<T> doc) {
    return init(() => doc, key: ValueKey(doc));
  }

  static final instance = LoonDocumentActionBuilder();
}

extension DocumentExtension on Haste {
  LoonDocumentActionBuilder get doc => LoonDocumentActionBuilder.instance;
}
