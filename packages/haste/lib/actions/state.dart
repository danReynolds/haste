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
  const StateActionBuilder();

  StateAction<S> call<S>(S initialValue, {Key? key}) {
    return rebuild(key, () => StateAction(initialValue));
  }

  StateAction<S> init<S>(S Function() initializer, {Key? key}) {
    return rebuild(key, () => StateAction(initializer()));
  }
}
