part of '../haste.dart';

class DisposeAction<T> extends HasteAction<T> {
  void Function() _dispose;

  DisposeAction(this._dispose);

  @override
  dispose() {
    _dispose();
  }
}

class DisposeActionBuilder extends HasteActionBuilder {
  void call(void Function() dispose) {
    final action = rebuild(null, () => DisposeAction(dispose));
    action._dispose = dispose;
  }
}
