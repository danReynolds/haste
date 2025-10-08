# Haste ⚡️ - Loon

An extension to [Haste](https://github.com/danReynolds/haste/tree/main/packages/haste) with added actions for [Computables](https://github.com/danReynolds/computables).

## Install

```dart
flutter pub add haste_computables
```

## Actions

* `compute` ➡️ Subscribe to a Computable.

```dart
import 'package:haste/haste.dart';
import 'package:haste_loon/haste_computables.dart';

class MyWidget extends StatelessWidget with Haste {
  @override
  build(context) {
    final value = compute(Computable(2));

    return Text(value);
  }
}
```