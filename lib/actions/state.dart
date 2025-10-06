part of '../haste.dart';

class StateAction<T> extends HasteAction<T> {
  T _value;

  StateAction(this._value, {super.key});

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
  StateActionBuilder(super.element);

  StateAction<S> call<S>(S initialValue, {key}) {
    return _register(StateAction(initialValue, key: key));
  }

  StateAction<S> init<S>(S Function() initializer, {key}) {
    return call(initializer(), key: key);
  }
}
