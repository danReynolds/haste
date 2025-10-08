part of '../haste.dart';

class MemoAction<T> extends HasteAction<T> {
  final T _value;

  MemoAction(this._value);
}

class MemoActionBuilder extends HasteActionBuilder {
  T call<T>(T Function() memoizer, {Key? key}) {
    return rebuild(key, () => MemoAction(memoizer()))._value;
  }
}
