part of '../haste.dart';

class DisposeAction<T> extends HasteAction<T> {
  void Function() _dispose;

  DisposeAction(this._dispose, {super.key});

  @override
  dispose() {
    _dispose();
  }
}

class DisposeActionBuilder extends HasteActionBuilder {
  DisposeActionBuilder(super.element);

  void call(void Function() dispose) {
    final action = _register(DisposeAction(dispose));
    action._dispose = dispose;
  }
}
