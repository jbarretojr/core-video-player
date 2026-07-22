import 'package:flutter/material.dart';

import 'full_example/full_example_app.dart';
import 'simple_example.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ExampleMenuPage());
  }
}

/// Lets the user pick between the two example apps: a minimal usage of
/// [CorePlayer] and a more complete demo with playlist, miniplayer, auto
/// rotation and settings.
class ExampleMenuPage extends StatelessWidget {
  const ExampleMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Video Player')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text('Simple example'),
            subtitle: const Text('Basic CorePlayer usage'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SimpleExamplePage())),
          ),
          ListTile(
            leading: const Icon(Icons.video_library_outlined),
            title: const Text('Full example'),
            subtitle: const Text('Playlist, miniplayer, auto rotation and settings'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FullExamplePage())),
          ),
        ],
      ),
    );
  }
}
