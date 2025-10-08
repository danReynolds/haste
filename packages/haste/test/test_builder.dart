import 'package:flutter/widgets.dart';
import 'package:haste/haste.dart';

class TestBuilder extends StatelessWidget with Haste {
  const TestBuilder({super.key, required this.builder});

  final Widget Function(Haste) builder;

  @override
  Widget build(BuildContext context) {
    return builder(this);
  }
}
