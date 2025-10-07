part of '../haste.dart';

class StreamAction<T> extends HasteAction<T> {
  AsyncSnapshot<T> _snap;
  late StreamSubscription _subscription;

  StreamAction(Stream<T> stream, {T? initialData})
    : _snap = initialData == null
          ? AsyncSnapshot<T>.nothing()
          : AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T) {
    _subscription = stream.listen(
      (data) {
        _snap = AsyncSnapshot<T>.withData(ConnectionState.active, data);
        _element.markNeedsBuild();
      },
      onError: (error, stackTrace) {
        _snap = AsyncSnapshot<T>.withError(
          ConnectionState.active,
          error,
          stackTrace,
        );
        _element.markNeedsBuild();
      },
      onDone: () {
        _snap = _snap.inState(ConnectionState.done);
        _element.markNeedsBuild();
      },
    );
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class StreamActionBuilder extends HasteActionBuilder {
  AsyncSnapshot<T> init<T>(
    Stream<T> Function() initializer, {
    Key? key,
    T? initialData,
  }) {
    return _rebuild(
      key,
      () => StreamAction(initializer(), initialData: initialData),
    )._snap;
  }

  AsyncSnapshot<T> call<T>(Stream<T> stream, {Key? key, T? initialData}) {
    return init(
      () => stream,
      key: key ?? ValueKey(stream),
      initialData: initialData,
    );
  }
}
