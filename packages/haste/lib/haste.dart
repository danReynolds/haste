import 'dart:async';
import 'package:flutter/widgets.dart';

export 'widgets/haste_builder.dart';

part 'actions/init.dart';
part 'actions/state.dart';
part 'actions/memo.dart';
part 'actions/dispose.dart';
part 'actions/future.dart';
part 'actions/stream.dart';
part 'actions/on_change.dart';

abstract class HasteAction<T> {
  late final Key? _key;
  late final HasteElement _element;

  void markNeedsBuild() {
    _element.markNeedsBuild();
  }

  void dispose() {}
}

abstract class HasteActionBuilder<T> {
  const HasteActionBuilder();

  HasteElement get _element => HasteElement._current!;

  S? retrieve<S extends HasteAction>() => _element._retrieveAction<S>();

  S rebuild<S extends HasteAction>(Key? key, S Function() actionBuilder) =>
      _element._rebuildAction(key, actionBuilder);
}

class HasteElement extends StatelessElement {
  /// The list of actions built by this element.
  List<HasteAction> _actions = [];

  HasteElement(super.widget);

  /// The current element being built.
  static HasteElement? _current;

  /// The current action index of the current element being built.
  static int _currentActionIndex = 0;

  T? _retrieveAction<T extends HasteAction>() {
    if (_current!._actions.elementAtOrNull(HasteElement._currentActionIndex)
        case T currentAction) {
      return currentAction;
    }

    return null;
  }

  T _rebuildAction<T extends HasteAction>(
    Key? key,
    T Function() actionBuilder,
  ) {
    final actionIndex = _currentActionIndex++;

    if (_actions.elementAtOrNull(actionIndex) case T currentAction) {
      if (currentAction._key == key) {
        return currentAction;
      }

      // If the action's type is the same but its key has changed, dispose it and recreate the action.
      currentAction.dispose();
      final action = _actions[actionIndex] = actionBuilder();
      action._key = key;
      action._element = this;

      return action;
    }

    // If the action's type has changed, then all actions after it are invalidated and disposed.
    if (actionIndex < _actions.length) {
      for (int i = actionIndex; i < _actions.length; i++) {
        final action = _actions[i];
        action.dispose();
      }
      _actions = _actions.sublist(0, actionIndex);
    }

    final action = actionBuilder();
    action._key = key;
    action._element = this;
    _actions.add(action);

    return action;
  }

  @override
  Widget build() {
    try {
      HasteElement._current = this;
      return super.build();
    } finally {
      HasteElement._current = null;
      _currentActionIndex = 0;
    }
  }

  @override
  unmount() {
    for (final action in _actions) {
      action.dispose();
    }
    super.unmount();
  }
}

const _init = InitActionBuilder();
const _state = StateActionBuilder();
const _memo = MemoActionBuilder();
const _dispose = DisposeActionBuilder();
const _future = FutureActionBuilder();
const _stream = StreamActionBuilder();
const _onChange = OnChangeActionBuilder();

mixin Haste on StatelessWidget {
  @override
  HasteElement createElement() => HasteElement(this);

  InitActionBuilder get init => _init;
  StateActionBuilder get state => _state;
  MemoActionBuilder get memo => _memo;
  DisposeActionBuilder get dispose => _dispose;
  FutureActionBuilder get future => _future;
  StreamActionBuilder get stream => _stream;
  OnChangeActionBuilder get onChange => _onChange;
}
