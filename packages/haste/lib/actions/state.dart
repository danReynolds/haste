part of '../haste.dart';

typedef StateActionRecord<S> = (S value, void Function(S newValue) update);

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

  StateActionRecord<S> init<S>(S Function() initializer, {Key? key}) {
    final action = rebuild(key, () => StateAction(initializer()));
    return (action._value, (newValue) => action.value = newValue);
  }

  StateActionRecord<S> call<S>(S initialValue, {Key? key}) {
    return init(() => initialValue, key: key);
  }
}
