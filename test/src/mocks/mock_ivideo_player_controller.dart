import 'package:flutter/foundation.dart';
import 'package:core_video_player/src/contracts/ivideo_player_controller.dart';
import 'package:video_player/video_player.dart';

class MockPlayerController extends IVideoPlayerController {
  @override
  IVideoPlayerController create({
    required Uri dataSource,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    bool? toggleViewType,
  }) {
    controller = ValueNotifier(const VideoPlayerValue(duration: Duration.zero));
    return this;
  }

  @override
  Future<void> initialize() async {
    controller?.value = value.copyWith(isInitialized: true);
    return;
  }

  @override
  Future<void> pause() async {
    controller?.value = value.copyWith(isPlaying: false);
    return;
  }

  @override
  Future<void> play() async {
    controller?.value = value.copyWith(isPlaying: true);
    return;
  }

  @override
  Future<void> seekTo(Duration position) async {
    return;
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    return;
  }

  @override
  Future<void> setVolume(double volume) async {
    return;
  }
}
