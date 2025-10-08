import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haste/haste.dart';
import 'package:loon/loon.dart';

class LoonQueryAction<T> extends HasteAction {
  final Query<T> _query;
  late final StreamSubscription<List<DocumentSnapshot<T>>> _subscription;

  LoonQueryAction(Queryable<T> queryable) : _query = queryable.toQuery() {
    _subscription = _query.toQuery().stream().listen((snap) {
      markNeedsBuild();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class LoonQueryActionBuilder extends HasteActionBuilder {
  List<DocumentSnapshot<T>> init<T>(
    Queryable<T> Function() initializer, {
    Key? key,
  }) {
    return rebuild(key, () => LoonQueryAction(initializer()))._query.get();
  }

  List<DocumentSnapshot<T>> call<T>(Queryable<T> queryable, {Key? key}) {
    return init(() => queryable, key: key ?? ValueKey(queryable));
  }

  static final instance = LoonQueryActionBuilder();
}

extension QueryExtension on Haste {
  LoonQueryActionBuilder get query => LoonQueryActionBuilder.instance;
}
