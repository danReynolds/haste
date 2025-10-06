import 'package:flutter/widgets.dart';

part 'actions/state.dart';
part 'actions/memo.dart';
part 'actions/dispose.dart';

abstract class HasteAction<T> {
  late final Key? _key;
  late final HasteElement _element;

  void dispose() {}
}

abstract class HasteActionBuilder<T> {
  S _rebuild<S extends HasteAction>(Key? key, S Function() actionBuilder) {
    return HasteElement._current!._rebuildAction(key, actionBuilder);
  }
}

class HasteElement extends StatelessElement {
  /// The list of actions registered in this element.
  List<HasteAction> _actions = [];

  HasteElement(super.widget);

  /// The current element being built.
  static HasteElement? _current;

  /// The current action index being processed by the current element.
  static int _currentActionIndex = 0;

  T _rebuildAction<T extends HasteAction>(
    Key? key,
    T Function() actionBuilder,
  ) {
    final actionIndex = _currentActionIndex++;

    if (_actions.elementAtOrNull(actionIndex) case T currentAction
        when currentAction._key == key) {
      return currentAction;
    }

    for (int i = actionIndex; i < _actions.length; i++) {
      final action = _actions[i];
      action.dispose();
    }

    final action = actionBuilder();
    action._key = key;
    action._element = this;
    _actions = _actions.sublist(0, actionIndex);
    _actions.add(action);

    return action;
  }

  @override
  Widget build() {
    HasteElement._current = this;

    final child = super.build();

    _currentActionIndex = 0;
    HasteElement._current = null;

    return child;
  }

  @override
  unmount() {
    for (final action in _actions) {
      action.dispose();
    }
    super.unmount();
  }

  static final state = StateActionBuilder();
  static final memo = MemoActionBuilder();
  static final dispose = DisposeActionBuilder();
}

mixin Haste on StatelessWidget {
  @override
  HasteElement createElement() => HasteElement(this);

  final state = HasteElement.state;
  final memo = HasteElement.memo;
  final dispose = HasteElement.dispose;
}
