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

// import 'package:flutter/material.dart';
// import 'package:core_video_player/core_video_player.dart';

// void main() => runApp(const MaterialApp(home: SimpleExamplePage()));

/// Minimal usage of [CorePlayer]: a single video with a fixed datasource
/// and no next/previous, miniplayer or fullscreen rotation handling.
// class SimpleExamplePage extends StatefulWidget {
//   const SimpleExamplePage({super.key});

//   @override
//   State<SimpleExamplePage> createState() => _SimpleExamplePageState();
// }

// class _SimpleExamplePageState extends State<SimpleExamplePage> {
//   final CorePlayerController playerController = CorePlayerController.init();
//   final Map<CorePlayerResolution, Uri> resolutions = {
//     CorePlayerResolution.p480: Uri.parse(
//       'https://dn801203.us.archive.org/0/items/BigBuckBunny_328/BigBuckBunny_512kb.mp4',
//     ),
//     CorePlayerResolution.p720: Uri.parse('https://www.papytane.com/mp4/bonjour.mp4'),
//     CorePlayerResolution.p1080: Uri.parse('https://www.papytane.com/mp4/paysborn.mp4'),
//   };

//   @override
//   void initState() {
//     super.initState();
//     playerController.changeDatasource(
//       CorePlayerDatasource(
//         title: 'Sample title',
//         description: 'Sample description',
//         banner: Uri.parse(
//           'https://blog.codemagic.io/uploads/covers/codemagic-blog-youtube-flutter-from-scratch-flutter-project-structure-and-widgets-3-thumbnail.png',
//         ),
//         hasNext: false,
//         hasPrev: false,
//         resolutions: resolutions,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     playerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Simple example')),
//       body: SafeArea(
//         child: AspectRatio(
//           aspectRatio: 16 / 9,
//           child: CorePlayer(
//             playerController,
//             onTapConfig: (CorePlayerControlsConfig config) {},
//             onTapSpeed: (CorePlayerControlsConfig config) {},
//           ),
//         ),
//       ),
//     );
//   }
// }

/// See the full example at:
/// https://github.com/jbarretojr/core-video-player/blob/master/example/lib/full_example/full_example_app.dart