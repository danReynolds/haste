import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

class UserModel {
  final String name;

  UserModel(this.name);
}

final randomNames = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Frank',
  'Heidi',
];

class LoadUserDemo extends StatelessWidget with Haste {
  const LoadUserDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final (key, setKey) = state.init(() => UniqueKey());

    final userSnap = future.init(
      // Initialize the load user future on first build.
      () => Future.delayed(
        Duration(seconds: 2),
        () => UserModel((randomNames..shuffle()).first),
      ),
      // The future will be reinitialized whenever the key changes.
      key: key,
    );

    return Center(
      child: Column(
        children: [
          Text(
            'Load user demo',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          switch (userSnap.connectionState) {
            ConnectionState.done => Column(
              spacing: 12,
              children: [
                Text('User: ${userSnap.data!.name}'),
                ElevatedButton(
                  onPressed: () {
                    setKey(UniqueKey());
                  },
                  child: Text('Fetch new user'),
                ),
              ],
            ),
            _ => CircularProgressIndicator(),
          },
        ],
      ),
    );
  }
}
