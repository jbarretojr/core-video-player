import 'package:flutter/material.dart';
import 'package:core_video_player/core_video_player.dart';

void main() => runApp(const MaterialApp(home: SimpleExamplePage()));

/// Minimal usage of [CorePlayer]: a single video with a fixed datasource
/// and no next/previous, miniplayer or fullscreen rotation handling.
class SimpleExamplePage extends StatefulWidget {
  const SimpleExamplePage({super.key});

  @override
  State<SimpleExamplePage> createState() => _SimpleExamplePageState();
}

class _SimpleExamplePageState extends State<SimpleExamplePage> {
  final CorePlayerController playerController = CorePlayerController.init();
  final Map<CorePlayerResolution, Uri> resolutions = {
    CorePlayerResolution.p480: Uri.parse(
      'https://dn801203.us.archive.org/0/items/BigBuckBunny_328/BigBuckBunny_512kb.mp4',
    ),
    CorePlayerResolution.p720: Uri.parse('https://www.papytane.com/mp4/bonjour.mp4'),
    CorePlayerResolution.p1080: Uri.parse('https://www.papytane.com/mp4/paysborn.mp4'),
  };

  @override
  void initState() {
    super.initState();
    playerController.changeDatasource(
      CorePlayerDatasource(
        title: 'Sample title',
        description: 'Sample description',
        banner: Uri.parse(
          'https://blog.codemagic.io/uploads/covers/codemagic-blog-youtube-flutter-from-scratch-flutter-project-structure-and-widgets-3-thumbnail.png',
        ),
        hasNext: false,
        hasPrev: false,
        resolutions: resolutions,
      ),
    );
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple example')),
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CorePlayer(
            playerController,
            onTapConfig: (CorePlayerControlsConfig config) {},
            onTapSpeed: (CorePlayerControlsConfig config) {},
          ),
        ),
      ),
    );
  }
}
