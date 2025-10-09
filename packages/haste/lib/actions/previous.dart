part of '../haste.dart';

class PreviousAction<T> extends HasteAction<T> {
  T _value;

  PreviousAction(this._value);
}

class PreviousActionBuilder extends HasteActionBuilder {
  const PreviousActionBuilder();

  T? call<T>(T value) {
    final prevValue = retrieve<PreviousAction>()?._value;

    final action = rebuild(null, () => PreviousAction(value));
    action._value = value;

    return prevValue;
  }
}
