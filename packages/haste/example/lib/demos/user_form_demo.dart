import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

class UserModel {
  final String name;

  UserModel(this.name);
}

class UserFormDemo extends StatelessWidget with Haste {
  UserFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final users = state(<UserModel>[]);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${users.value.length} users',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Column(
              children: users.value
                  .map(
                    (user) => Row(
                      spacing: 12,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            users.value = users.value
                                .where((u) => u != user)
                                .toList();
                          },
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return UserForm(
                    onSubmit: (user) {
                      users.value = [...users.value, user];
                    },
                  );
                },
              );
            },
            tooltip: 'Add user',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class UserForm extends StatelessWidget with Haste {
  final void Function(UserModel user) onSubmit;

  UserForm({super.key, required this.onSubmit});

  @override
  build(context) {
    final controller = memo(() => TextEditingController());
    dispose(() => controller.dispose());

    return Material(
      child: Container(
        width: 500,
        height: 500,
        alignment: Alignment.center,
        child: Column(
          spacing: 12,
          children: [
            Text('Add user', style: Theme.of(context).textTheme.headlineMedium),
            TextField(controller: controller),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onSubmit(UserModel(controller.text));
              },
            ),
          ],
        ),
      ),
    );
  }
}
