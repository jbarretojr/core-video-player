import 'package:flutter/material.dart';
import 'package:core_video_player/core_video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  CorePlayerController playerController = CorePlayerController.init();
  Map<CorePlayerResolution, Uri> resolutions = {
    CorePlayerResolution.p480: Uri.parse(
      'https://dn801203.us.archive.org/0/items/BigBuckBunny_328/BigBuckBunny_512kb.mp4',
    ),
  };

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Core Video Player')),
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
      ),
    );
  }
}
