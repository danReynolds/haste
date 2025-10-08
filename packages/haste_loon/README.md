# Haste ⚡️ - Loon

An extension to [Haste](https://github.com/danReynolds/haste/tree/main/packages/haste) with added actions for [Loon](https://github.com/danReynolds/loon).

## Install

```dart
flutter pub add haste_loon
```

## Actions

* `doc` ➡️ Subscribe to a Loon document.

```dart
import 'package:haste/haste.dart';
import 'package:haste_loon/haste_loon.dart';

class UserModel {
  final String name;

  UserModel({ required this.name });
}

final users = Loon.collection<UserModel>('users');

class MyWidget extends StatelessWidget with Haste {
  @override
  build(context) {
    final userSnap = doc(users.doc('1'));

    return Text(userSnap.data.name);
  }
}
```

* `query` ➡️ Subscribe to a Loon query.

```dart
import 'package:haste/haste.dart';
import 'package:haste_loon/haste_loon.dart';

class UserModel {
  final String name;

  UserModel({ required this.name });
}

final users = Loon.collection<UserModel>('users');

class MyWidget extends StatelessWidget with Haste {
  @override
  build(context) {
    final userSnaps = doc(users.where((snap) => snap.data.name == "User 1"));

    return Text("Matching users: ${userSnaps.length}");
  }
}
```