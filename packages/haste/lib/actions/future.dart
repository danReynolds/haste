part of '../haste.dart';

class FutureAction<T> extends HasteAction<T> {
  AsyncSnapshot<T> _snap;
  bool _disposed = false;

  FutureAction(Future<T> future, {T? initialData})
    : _snap = initialData == null
          ? AsyncSnapshot<T>.nothing()
          : AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T) {
    future
        .then(
          (result) {
            _snap = AsyncSnapshot<T>.withData(ConnectionState.done, result);
          },
          onError: (error, stackTrace) {
            _snap = AsyncSnapshot<T>.withError(
              ConnectionState.done,
              error,
              stackTrace,
            );
          },
        )
        .whenComplete(() {
          if (!_disposed) {
            _element.markNeedsBuild();
          }
        });
  }

  @override
  dispose() {
    _disposed = true;
    super.dispose();
  }
}

class FutureActionBuilder extends HasteActionBuilder {
  const FutureActionBuilder();

  AsyncSnapshot<T> init<T>(
    Future<T> Function() initializer, {
    Key? key,
    T? initialData,
  }) {
    return rebuild(
      key,
      () => FutureAction(initializer(), initialData: initialData),
    )._snap;
  }

  AsyncSnapshot<T> call<T>(Future<T> future, {Key? key, T? initialData}) {
    return init(
      () => future,
      key: key ?? ValueKey(future),
      initialData: initialData,
    );
  }
}
