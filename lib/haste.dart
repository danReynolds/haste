import 'package:flutter/widgets.dart';

part 'actions/state.dart';
part 'actions/memo.dart';
part 'actions/dispose.dart';

abstract class HasteAction<T> {
  final Key? _key;
  late final HasteElement _element;

  HasteAction({Key? key}) : _key = key;

  void dispose() {}
}

abstract class HasteActionBuilder<T> {
  final HasteElement _element;

  HasteActionBuilder(this._element);

  S _register<S extends HasteAction>(S action) {
    return _element._registerAction(action);
  }
}

class HasteElement extends StatelessElement {
  int _actionIndex = 0;

  List<HasteAction> _actions = [];

  HasteElement(super.widget);

  T _registerAction<T extends HasteAction>(T action) {
    final currentIndex = _actionIndex++;

    if (_actions.elementAtOrNull(currentIndex) case T currentAction
        when currentAction._key == action._key) {
      return currentAction;
    }

    for (int i = currentIndex; i < _actions.length; i++) {
      final action = _actions[i];
      action.dispose();
    }

    action._element = this;
    _actions = _actions.sublist(0, currentIndex);
    _actions.add(action);

    return action;
  }

  @override
  Widget build() {
    final child = super.build();
    _actionIndex = 0;
    return child;
  }

  @override
  void update(covariant Haste newWidget) {
    newWidget._element = this;
    super.update(newWidget);
  }

  @override
  unmount() {
    for (final action in _actions) {
      action.dispose();
    }
    super.unmount();
  }
}

mixin Haste on StatelessWidget {
  late HasteElement _element;

  @override
  HasteElement createElement() => _element = HasteElement(this);

  late final state = StateActionBuilder(_element);
  late final memo = MemoActionBuilder(_element);
  late final dispose = DisposeActionBuilder(_element);
}
