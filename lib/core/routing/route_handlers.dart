import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

final Handler homeHandler = Handler(
  handlerFunc: (context, params) => const _HomePlaceholderScreen(),
);

class _HomePlaceholderScreen extends StatelessWidget {
  const _HomePlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Movies Challenge')),
      body: const Center(
        child: Text('Routing and theme are wired up.'),
      ),
    );
  }
}
