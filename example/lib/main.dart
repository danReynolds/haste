import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

class UserModel {
  final String name;

  UserModel(this.name);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget with Haste {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final users = state(<UserModel>[]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${users.value.length} users',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Column(
              children: users.value.map((user) => Text(user.name)).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
