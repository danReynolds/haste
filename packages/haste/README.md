
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
        AgePicker(initialValue: 0, onPick: (updatedAge) {
          setState(() {
            _age = updatedAge;
          })
        }),
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            widget.submit(age: _age, name: _controller.text);
          },
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
    final controller = memo(() => TextEditingController());
    final age = state(0);

    return Column(
      children: [
        TextField(controller: _controller, hintText: 'Name'),
        AgePicker(initialValue: 0, onPick: (updatedAge) {
          age.value = updatedAge;
        }),
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            widget.submit(age: age.value, name: _controller.text);
          },
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

## Install

```bash
flutter pub add haste
```

## Demos

1. [User form](./example/lib/demos/user_form_demo.dart) (actions - `state`)
2. [Load user](./example/lib/demos/load_user_demo.dart) (actions - `state`, `future`)
3. [Football score](./example/lib/demos/football_score_demo.dart) (actions - `stream`, `init`, `onChange`)

## Extensions

Need actions for a particular library? You can explore extensions below:

* [Computables](https://pub.dev/packages/haste_computables) - A reactive state primitive library. [Extension](../haste_loon/README.md).
* [Loon](https://pub.dev/packages/haste_loon) - Loon is a reactive document data store for Flutter. [Extension](../haste_loon/README.md).


