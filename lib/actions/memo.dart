part of '../haste.dart';

class MemoAction<T> extends HasteAction<T> {
  final T _value;

  MemoAction(this._value, {super.key});
}

class MemoActionBuilder extends HasteActionBuilder {
  MemoActionBuilder(super.element);

  T call<T>(T Function() memoizer, {key}) {
    return _register(MemoAction(memoizer(), key: key))._value;
  }
}
