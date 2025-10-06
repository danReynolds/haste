part of '../haste.dart';

class StateAction<T> extends HasteAction<T> {
  T _value;

  StateAction(this._value);

  T get value {
    return _value;
  }

  set value(T newValue) {
    if (_value != newValue) {
      _element.markNeedsBuild();
    }

    _value = newValue;
  }
}

class StateActionBuilder extends HasteActionBuilder {
  StateAction<S> call<S>(S initialValue, {key}) {
    return _rebuild(key, () => StateAction(initialValue));
  }

  StateAction<S> init<S>(S Function() initializer, {key}) {
    return call(initializer(), key: key);
  }
}
