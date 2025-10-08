import 'package:example/demos/football_score_demo.dart';
import 'package:example/demos/load_user_demo.dart';
import 'package:example/demos/user_form_demo.dart';
import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

void main() {
  runApp(const DemoApp());
}

enum Demos { userForm, loadUser, footballScore }

class DemoApp extends StatelessWidget with Haste {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final (selectedDemo, setSelectedDemo) = state(Demos.userForm);

    return MaterialApp(
      title: 'Haste Demos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Haste Demos'),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Container(
          width: 200,
          padding: EdgeInsets.only(top: 24),
          color: Colors.white,
          child: Column(
            spacing: 12,
            children: [
              Text('Demos', style: Theme.of(context).textTheme.headlineSmall),
              ...Demos.values.map(
                (demo) => ListTile(
                  title: Text(demo.name),
                  selected: selectedDemo == demo,
                  onTap: () {
                    setSelectedDemo(demo);
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: switch (selectedDemo) {
            Demos.userForm => UserFormDemo(),
            Demos.loadUser => LoadUserDemo(),
            Demos.footballScore => FootballScoreDemo(),
          },
        ),
      ),
    );
  }
}
