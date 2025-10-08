part of '../haste.dart';

class InitAction<T> extends HasteAction<T> {}

class InitActionBuilder extends HasteActionBuilder {
  void call<S>(void Function() onInit) {
    if (retrieve<InitAction>() == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onInit();
      });
    }

    rebuild(null, () => InitAction());
  }
}
