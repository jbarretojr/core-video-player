import 'package:flutter/foundation.dart';
import 'package:core_video_player/src/core_player_controller.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';
import 'package:core_video_player/src/models/core_player_controls_mode.dart';
import 'package:core_video_player/src/models/core_player_resolution.dart';

/// Stores the state of the player.
///
/// Used with a ValueNotifier in [CorePlayerController] to notify the
/// widgets that depend on the player's state.
@immutable
class CorePlayerState {
  const CorePlayerState({
    required this.isInitialized,
    required this.isLoading,
    required this.isPlaying,
    required this.isFullscreen,
    required this.showControls,
    required this.showSubtitles,
    required this.isSeeking,
    required this.isNewPositioning,
    required this.isBuffering,
    required this.isPipSupported,
    required this.inPip,
    required this.isFinished,
    required this.position,
    required this.buffered,
    required this.duration,
    required this.speed,
    required this.resolution,
    required this.cast,
    required this.controlsMode,
    this.subtitleText = '',
  });

  /// Creates an uninitialized state.
  const CorePlayerState.uninitialized()
    : this(
        isInitialized: false,
        isLoading: false,
        isPlaying: false,
        isFullscreen: false,
        showControls: false,
        showSubtitles: true,
        isSeeking: false,
        isNewPositioning: false,
        isBuffering: false,
        isPipSupported: false,
        inPip: false,
        isFinished: false,
        position: Duration.zero,
        buffered: Duration.zero,
        duration: Duration.zero,
        speed: 1,
        resolution: CorePlayerResolution.p480,
        cast: CorePlayerCast.disconnect,
        controlsMode: CorePlayerControlsMode.auto,
      );

  /// Indicates whether the player has been initialized.
  final bool isInitialized;

  /// Indicates whether the player is loading.
  final bool isLoading;

  /// Indicates whether the player is playing.
  final bool isPlaying;

  /// Indicates whether the player is in fullscreen.
  final bool isFullscreen;

  /// Indicates whether the player controls are visible.
  final bool showControls;

  /// Indicates whether subtitles are enabled.
  final bool showSubtitles;

  /// Indicates whether a new video position is being applied.
  final bool isNewPositioning;

  /// Indicates whether the video position is being changed.
  final bool isSeeking;

  /// Indicates whether the player is buffering the video.
  final bool isBuffering;

  /// Indicates whether picture-in-picture mode is supported.
  final bool isPipSupported;

  /// Indicates whether the player is in picture-in-picture.
  final bool inPip;

  /// Indicates whether the video has finished.
  final bool isFinished;

  /// Current position of the video.
  final Duration position;

  /// Buffered duration of the video.
  final Duration buffered;

  /// Duration of the video.
  final Duration duration;

  /// Playback speed of the video.
  final double speed;

  /// Resolution of the video.
  final CorePlayerResolution resolution;

  /// Chromecast connection state.
  final CorePlayerCast cast;

  /// Controls display mode.
  final CorePlayerControlsMode controlsMode;

  /// Subtitle text.
  final String subtitleText;

  CorePlayerState copyWith({
    bool? isInitialized,
    bool? isLoading,
    bool? isPlaying,
    bool? isFullscreen,
    bool? showControls,
    bool? showSubtitles,
    bool? isSeeking,
    bool? isNewPositioning,
    bool? isBuffering,
    bool? isPipSupported,
    bool? inPip,
    bool? isFinished,
    Duration? position,
    Duration? buffered,
    Duration? duration,
    double? speed,
    CorePlayerResolution? resolution,
    CorePlayerCast? cast,
    CorePlayerControlsMode? controlsMode,
    String? subtitleText,
  }) {
    return CorePlayerState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      showControls: showControls ?? this.showControls,
      showSubtitles: showSubtitles ?? this.showSubtitles,
      isSeeking: isSeeking ?? this.isSeeking,
      isNewPositioning: isNewPositioning ?? this.isNewPositioning,
      isBuffering: isBuffering ?? this.isBuffering,
      isPipSupported: isPipSupported ?? this.isPipSupported,
      inPip: inPip ?? this.inPip,
      isFinished: isFinished ?? this.isFinished,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      resolution: resolution ?? this.resolution,
      cast: cast ?? this.cast,
      controlsMode: controlsMode ?? this.controlsMode,
      subtitleText: subtitleText ?? this.subtitleText,
    );
  }

  @override
  String toString() {
    return 'CorePlayerState('
        'isInitialized: $isInitialized, '
        'isLoading: $isLoading, '
        'isPlaying: $isPlaying, '
        'isFullscreen: $isFullscreen, '
        'showControls: $showControls, '
        'showSubtitles: $showSubtitles, '
        'isSeeking: $isSeeking, '
        'isNewPositioning: $isNewPositioning, '
        'isBuffering: $isBuffering, '
        'isPipSupported: $isPipSupported, '
        'inPip: $inPip, '
        'isFinished: $isFinished, '
        'position: $position, '
        'buffered: $buffered, '
        'duration: $duration, '
        'speed: $speed, '
        'resolution: $resolution, '
        'cast: $cast, '
        'controlsMode: $controlsMode, '
        'subtitleText: $subtitleText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CorePlayerState &&
        other.isInitialized == isInitialized &&
        other.isLoading == isLoading &&
        other.isPlaying == isPlaying &&
        other.isFullscreen == isFullscreen &&
        other.showControls == showControls &&
        other.showSubtitles == showSubtitles &&
        other.isSeeking == isSeeking &&
        other.isNewPositioning == isNewPositioning &&
        other.isBuffering == isBuffering &&
        other.isPipSupported == isPipSupported &&
        other.inPip == inPip &&
        other.isFinished == isFinished &&
        other.position.inSeconds == position.inSeconds &&
        other.buffered.inSeconds == buffered.inSeconds &&
        other.duration.inSeconds == duration.inSeconds &&
        other.speed == speed &&
        other.resolution == resolution &&
        other.cast == cast &&
        other.controlsMode == controlsMode &&
        other.subtitleText == subtitleText;
  }

  @override
  int get hashCode {
    return Object.hash(
      isInitialized,
      isLoading,
      isPlaying,
      isFullscreen,
      showControls,
      showSubtitles,
      isSeeking,
      isNewPositioning,
      isBuffering,
      isPipSupported,
      inPip,
      isFinished,
      position,
      buffered,
      duration,
      speed,
      resolution,
      cast,
      controlsMode,
      subtitleText,
    );
  }
}
