
# Haste ⚡️

You're locked in. All of a sudden you realize that your `StatelessWidget` widget needs a `TextEditingController`, or maybe a `FocusNode` or somple simple piece of boolean state. You don't have time to convert it to a `StatefulWidget`. You need a one-line solution. You need to act with *Haste*.

Similarly to the awesome [Flutter hooks](https://github.com/rrousselGit/flutter_hooks/tree/master) package, Haste lets you perform stateful actions in a `StatelessWidget`. Let's see how it looks!

## Pre-haste

```dart
class MyForm extends StatefulWidget {
  final Widget Function({
    required String name,
    required int age,
  }) submit;

  MyForm({ required this.submit });

  @override
  MyFormState createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  int _age = 0;
  TextEditingController _controller = TextEditingController();

  @override
  build(context) {
    return Column(
      children: [
        TextField(controller: _controller, hintText: 'Name'),
        AgePicker(initialValue: 0, onPick: (newAge) => setState(() => _age = newAge)),
        TextButton(
          child: Text('Submit'),
          onPressed: () => widget.submit(age: _age, name: _controller.text),
        ),
      ]
    )
  }
}
```

## Post-haste

```dart
class MyForm extends StatelessWidget with Haste {
  final Widget Function({
    required String name,
    required int age,
  }) submit;

  MyForm({ required this.submit });

  @override
  build(context) {
    final (age, setAge) = state(0);
    final controller = memo(() => TextEditingController());

    return Column(
      children: [
        TextField(controller: controller, hintText: 'Name'),
        AgePicker(initialValue: 0, onPick: (newAge) => setAge(newAge)),
        TextButton(
          child: Text('Submit'),
          onPressed: () => widget.submit(age: age, name: _controller.text),
        ),
      ]
    )
  }
}
```

## Actions

* `init` ➡️ Run some code when a `StatelessWidget` is initialized.
* `memo` ➡️ Memoize a value like a `TextEditingController`, `FocusNode`, etc.
* `state` ➡️ Setup a mutable piece of state in a `StatelessWidget`.
* `future` ➡️ Subscribe to a future.
* `stream` ➡️ Subscribe to a stream.
* `onChange` ➡️ Run some code when a value changes.
* `dispose` ➡️ Run some code when a `StatelessWidget` is disposed.
* `previous` ➡️ Return the previous value from the last build.

## Install

```bash
flutter pub add haste
```

## Demos

1. [User form](./example/lib/demos/user_form_demo.dart) (actions - `state`)
2. [Load user](./example/lib/demos/load_user_demo.dart) (actions - `state`, `future`)
3. [Football score](./example/lib/demos/football_score_demo.dart) (actions - `stream`, `init`, `onChange`)

## Extensions

Want extended actions for a particular library? You can find some extension packages below:

* [Computables](https://pub.dev/packages/haste_computables) - A reactive state primitive library. [Extension](../haste_loon/README.md).
* [Loon](https://pub.dev/packages/haste_loon) - Loon is a reactive document data store for Flutter. [Extension](../haste_loon/README.md).

## Creating extensions

Need an action you don't see yet? Create your own!

Let's take the example of creating an extended action called `counter` that periodically increments a value and rebuilds the widget:

```dart
class MyWidget extends StatelessWidget with Haste {
  @override
  build(context) {
    // Increment a counter beginning at 0 every 2 seconds.
    final count = counter(0, Duration(seconds: 2));
    return Text("Count: $count"); // Count: 0, Count: 1, Count: 2...
  }
}
```

And here is how you would implement it:

```dart
class CounterAction extends HasteAction<int> {
  int _count;
  late final Timer _timer;

  CounterAction(this._count, Duration duration) {
    _timer = Timer.periodic(duration, (_) {
      _count++;
      markNeedsBuild();
    });
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CounterActionBuilder extends HasteActionBuilder {
  const CounterActionBuilder();

  int call(int initialValue, Duration duration, {Key? key}) {
    // A new counter action is built whenever the provided key changes.
    final action = rebuild(key, () => CounterAction(initialValue, duration));
    return action._count;
  }
}

// Finally, extend the set of existing haste actions with the counter extension.
extension HasteCounterAction on Haste {
  CounterActionBuilder get counter => const CounterActionBuilder();
}
```