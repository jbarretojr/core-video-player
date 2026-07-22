import 'dart:async';

import 'package:core_video_player/src/models/core_player_datasource.dart';
import 'package:core_video_player/src/models/core_player_resolution.dart';
import 'package:core_video_player/src/models/core_player_state.dart';

/// Defines and stores the player's event callbacks.
class CorePlayerEvents {
  const CorePlayerEvents({
    this.onInitialized,
    this.onPlay,
    this.onPause,
    this.onProgress,
    this.onSeek,
    this.onNext,
    this.onPrev,
    this.onFinished,
    this.onChangedAutoPlay,
    this.onEnterFullscreen,
    this.onExitFullscreen,
    this.onTapEnterFullscreen,
    this.onTapExitFullscreen,
    this.onEnterChromecast,
    this.onExitChromecast,
    this.onReconnectChromecast,
    this.onControlsVisible,
    this.onControlsHidden,
    this.onChangedSpeed,
    this.onChangedSubtitles,
    this.onChangedResolution,
    this.onPipStart,
    this.onPipStop,
    this.onSetupDataSource,
    this.onBufferingUpdate,
    this.onClose,
    this.onError,
    this.onException,
  });

  /// Called when the player is initialized.
  final FutureOr<void> Function(CorePlayerDatasource)? onInitialized;

  /// Called when the player starts playing.
  final FutureOr<void> Function(CorePlayerState state)? onPlay;

  /// Called when the player is paused.
  final FutureOr<void> Function(CorePlayerState state)? onPause;

  /// Called while the player is playing and the playback position is
  /// updated.
  final FutureOr<void> Function(CorePlayerState state)? onProgress;

  /// Called when a seek action changes the playback position.
  final FutureOr<void> Function(Duration position, CorePlayerState state)? onSeek;

  /// Called when the next-video action is triggered.
  final FutureOr<void> Function(CorePlayerState state)? onNext;

  /// Called when the previous-video action is triggered.
  final FutureOr<void> Function(CorePlayerState state)? onPrev;

  /// Called when the video finishes playing.
  final FutureOr<void> Function(CorePlayerState state)? onFinished;

  /// Called when the auto-play setting changes.
  final FutureOr<void> Function(bool newValue)? onChangedAutoPlay;

  /// Called when the player enters fullscreen mode.
  final FutureOr<void> Function()? onEnterFullscreen;

  /// Called when the player exits fullscreen mode.
  final FutureOr<void> Function()? onExitFullscreen;

  /// Called only when the user taps the button to enter fullscreen.
  final FutureOr<void> Function()? onTapEnterFullscreen;

  /// Called only when the user taps the button to exit fullscreen.
  final FutureOr<void> Function()? onTapExitFullscreen;

  /// Called when the connect-to-chromecast action is triggered.
  final FutureOr<void> Function()? onEnterChromecast;

  /// Called when the disconnect-from-chromecast action is triggered.
  final FutureOr<void> Function()? onExitChromecast;

  /// Called when a reconnection with chromecast happens.
  final FutureOr<void> Function()? onReconnectChromecast;

  /// Called when the player controls are shown.
  final FutureOr<void> Function()? onControlsVisible;

  /// Called when the player controls are hidden.
  final FutureOr<void> Function()? onControlsHidden;

  /// Called when the playback speed changes.
  final FutureOr<void> Function(double speed)? onChangedSpeed;

  /// Called when the subtitles display setting changes.
  final FutureOr<void> Function(bool newValue)? onChangedSubtitles;

  /// Called when the video resolution changes.
  final FutureOr<void> Function(CorePlayerResolution resolution)? onChangedResolution;

  /// Called when picture-in-picture starts.
  final FutureOr<void> Function()? onPipStart;

  /// Called when picture-in-picture stops.
  final FutureOr<void> Function()? onPipStop;

  /// Called when a new video is loaded.
  final FutureOr<void> Function()? onSetupDataSource;

  /// Called when the video buffer is updated.
  final FutureOr<void> Function(Duration position)? onBufferingUpdate;

  /// Called when the close-player action is triggered.
  final FutureOr<void> Function(CorePlayerState state)? onClose;

  /// Called when an error occurs in the player.
  final FutureOr<void> Function(String message, [StackTrace? trace])? onError;

  /// Called when an exception occurs in the player.
  final FutureOr<void> Function(String message, [StackTrace? trace])? onException;
}
