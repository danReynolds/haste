import 'dart:async';

import 'package:flutter/widgets.dart';

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

  S? retrieve<S extends HasteAction>() {
    return HasteElement._current!._retrieveAction<S>();
  }

  S rebuild<S extends HasteAction>(Key? key, S Function() actionBuilder) {
    return HasteElement._current!._rebuildAction(key, actionBuilder);
  }
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

    if (_actions.elementAtOrNull(actionIndex) case T currentAction
        when currentAction._key == key) {
      return currentAction;
    }

    if (actionIndex != _actions.length) {
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

  static final init = InitActionBuilder();
  static final state = StateActionBuilder();
  static final memo = MemoActionBuilder();
  static final dispose = DisposeActionBuilder();
  static final future = FutureActionBuilder();
  static final stream = StreamActionBuilder();
  static final onChange = OnChangeActionBuilder();
}

mixin Haste on StatelessWidget {
  @override
  HasteElement createElement() => HasteElement(this);

  InitActionBuilder get init {
    return HasteElement.init;
  }

  StateActionBuilder get state {
    return HasteElement.state;
  }

  MemoActionBuilder get memo {
    return HasteElement.memo;
  }

  DisposeActionBuilder get dispose {
    return HasteElement.dispose;
  }

  FutureActionBuilder get future {
    return HasteElement.future;
  }

  StreamActionBuilder get stream {
    return HasteElement.stream;
  }

  OnChangeActionBuilder get onChange {
    return HasteElement.onChange;
  }
}
