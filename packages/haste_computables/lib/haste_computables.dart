import 'dart:async';
import 'package:computables/computables.dart';
import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

class ComputableAction<T> extends HasteAction {
  final Computable<T> _computable;
  late final StreamSubscription<T> _subscription;

  ComputableAction(this._computable) {
    _subscription = _computable.stream().listen((value) {
      markNeedsBuild();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class ComputableActionBuilder extends HasteActionBuilder {
  T init<T>(Computable<T> Function() initializer, {Key? key}) {
    return rebuild(
      key,
      () => ComputableAction(initializer()),
    )._computable.get();
  }

  T call<T>(Computable<T> computable, {Key? key}) {
    return init(() => computable, key: key ?? ValueKey(computable));
  }

  static final instance = ComputableActionBuilder();
}

extension ComputableExtension on Haste {
  ComputableActionBuilder get compute => ComputableActionBuilder.instance;
}
