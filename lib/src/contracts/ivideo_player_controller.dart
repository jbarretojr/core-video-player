import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

abstract class IVideoPlayerController<T extends ValueNotifier<VideoPlayerValue>> {
  T? controller;
  VideoPlayerValue get value => controller?.value ?? const VideoPlayerValue(duration: Duration.zero);

  void addListener(void Function() listener) {
    controller?.addListener(listener);
  }

  void removeListener(void Function() listener) {
    controller?.removeListener(listener);
  }

  @mustCallSuper
  Future<void> dispose() async {
    controller?.dispose();
  }

  IVideoPlayerController create({
    required Uri dataSource,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    bool? toggleViewType,
  });

  Future<void> initialize();

  Future<void> play();

  Future<void> pause();

  Future<void> setPlaybackSpeed(double speed);

  Future<void> seekTo(Duration position);

  Future<void> setVolume(double volume);
}

class PlayerController extends IVideoPlayerController<VideoPlayerController> {
  @override
  PlayerController create({
    required Uri dataSource,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    bool? toggleViewType,
  }) {
    controller = dataSource.isScheme('file')
        ? VideoPlayerController.file(
            File.fromUri(dataSource),
            closedCaptionFile: closedCaptionFile,
            videoPlayerOptions: videoPlayerOptions,
            viewType: toggleViewType == true ? VideoViewType.platformView : VideoViewType.textureView,
          )
        : VideoPlayerController.networkUrl(
            Uri.parse(dataSource.toString()),
            closedCaptionFile: closedCaptionFile,
            videoPlayerOptions: videoPlayerOptions,
            viewType: toggleViewType == true ? VideoViewType.platformView : VideoViewType.textureView,
          );

    return this;
  }

  @override
  Future<void> initialize() async => controller?.initialize();

  @override
  Future<void> play() async => controller?.play();

  @override
  Future<void> pause() async => controller?.pause();

  @override
  Future<void> seekTo(Duration position) async {
    await controller?.seekTo(position);
    await Future.delayed(const Duration(milliseconds: 500), () {});
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async => controller?.setPlaybackSpeed(speed);

  @override
  Future<void> setVolume(double volume) async => controller?.setVolume(volume);
}
