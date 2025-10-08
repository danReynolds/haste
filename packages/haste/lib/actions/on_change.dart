part of '../haste.dart';

class OnChangeAction<T> extends HasteAction<T> {}

class OnChangeActionBuilder extends HasteActionBuilder {
  void call<S>(void Function() onChange, {required Key key}) {
    final prevAction = retrieve<OnChangeAction>();
    final nextAction = rebuild(key, () => OnChangeAction());

    if (prevAction != null && prevAction != nextAction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChange();
      });
    }
  }
}
