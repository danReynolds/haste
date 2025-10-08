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
  T call<T>(Computable<T> computable, {Key? key}) {
    return rebuild(
      key ?? ValueKey(computable),
      () => ComputableAction(computable),
    )._computable.get();
  }

  static final instance = ComputableActionBuilder();
}

extension ComputableExtension on Haste {
  ComputableActionBuilder get compute => ComputableActionBuilder.instance;
}
