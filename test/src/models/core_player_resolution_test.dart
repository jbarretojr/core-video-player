import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';

void main() {
  test('CorePlayerResolution values', () {
    expect(CorePlayerResolution.values.length, equals(5));
  });

  test('CorePlayerResolution.p240', () {
    expect(CorePlayerResolution.values.contains(CorePlayerResolution.p240), true);
  });

  test('CorePlayerResolution.p360', () {
    expect(CorePlayerResolution.values.contains(CorePlayerResolution.p360), true);
  });

  test('CorePlayerResolution.p480', () {
    expect(CorePlayerResolution.values.contains(CorePlayerResolution.p480), true);
  });

  test('CorePlayerResolution.p720', () {
    expect(CorePlayerResolution.values.contains(CorePlayerResolution.p720), true);
  });

  test('CorePlayerResolution.p1080', () {
    expect(CorePlayerResolution.values.contains(CorePlayerResolution.p1080), true);
  });

  test('CorePlayerResolution toString() - 240p', () {
    const playerState = CorePlayerState(
      isInitialized: false,
      isLoading: false,
      isPlaying: false,
      isFullscreen: false,
      showControls: false,
      showSubtitles: false,
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
      resolution: CorePlayerResolution.p240,
      cast: CorePlayerCast.unavailable,
      controlsMode: CorePlayerControlsMode.alwaysHidden,
    );

    expect(playerState.resolution.toString(), '240p');
  });

  test('CorePlayerResolution toString() - 360p', () {
    const playerState = CorePlayerState(
      isInitialized: false,
      isLoading: false,
      isPlaying: false,
      isFullscreen: false,
      showControls: false,
      showSubtitles: false,
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
      resolution: CorePlayerResolution.p360,
      cast: CorePlayerCast.unavailable,
      controlsMode: CorePlayerControlsMode.alwaysHidden,
    );

    expect(playerState.resolution.toString(), '360p');
  });

  test('CorePlayerResolution toString() - 480p', () {
    const playerState = CorePlayerState(
      isInitialized: false,
      isLoading: false,
      isPlaying: false,
      isFullscreen: false,
      showControls: false,
      showSubtitles: false,
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
      cast: CorePlayerCast.unavailable,
      controlsMode: CorePlayerControlsMode.alwaysHidden,
    );

    expect(playerState.resolution.toString(), '480p');
  });

  test('CorePlayerResolution toString() - 720p', () {
    const playerState = CorePlayerState(
      isInitialized: false,
      isLoading: false,
      isPlaying: false,
      isFullscreen: false,
      showControls: false,
      showSubtitles: false,
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
      resolution: CorePlayerResolution.p720,
      cast: CorePlayerCast.unavailable,
      controlsMode: CorePlayerControlsMode.alwaysHidden,
    );

    expect(playerState.resolution.toString(), '720p');
  });

  test('CorePlayerResolution toString() - 1080p', () {
    const playerState = CorePlayerState(
      isInitialized: false,
      isLoading: false,
      isPlaying: false,
      isFullscreen: false,
      showControls: false,
      showSubtitles: false,
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
      resolution: CorePlayerResolution.p1080,
      cast: CorePlayerCast.unavailable,
      controlsMode: CorePlayerControlsMode.alwaysHidden,
    );

    expect(playerState.resolution.toString(), '1080p');
  });
}
