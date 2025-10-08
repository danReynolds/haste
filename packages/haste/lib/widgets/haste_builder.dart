import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

class HasteBuilder extends StatelessWidget with Haste {
  final Widget Function(BuildContext context, Haste actions) builder;

  const HasteBuilder({super.key, required this.builder});

  @override
  build(context) {
    return builder(context, this);
  }
}
