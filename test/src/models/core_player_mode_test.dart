import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';

void main() {
  test('CorePlayerControlsMode values', () {
    expect(CorePlayerControlsMode.values.length, equals(3));
  });

  test('CorePlayerControlsMode.auto', () {
    expect(CorePlayerControlsMode.values.contains(CorePlayerControlsMode.auto), true);
  });

  test('CorePlayerControlsMode.alwaysVisible', () {
    expect(CorePlayerControlsMode.values.contains(CorePlayerControlsMode.alwaysVisible), true);
  });

  test('CorePlayerControlsMode.alwaysHidden', () {
    expect(CorePlayerControlsMode.values.contains(CorePlayerControlsMode.alwaysHidden), true);
  });

  test('CorePlayerControlsMode.isAlwaysHidden', () {
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

    expect(playerState.controlsMode.isAlwaysHidden, true);
  });

  test('CorePlayerControlsMode.alwaysVisible', () {
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
      controlsMode: CorePlayerControlsMode.alwaysVisible,
    );

    expect(playerState.controlsMode.isAlwaysVisible, true);
  });

  test('CorePlayerControlsMode.alwaysVisible', () {
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
      controlsMode: CorePlayerControlsMode.auto,
    );

    expect(playerState.controlsMode.isAuto, true);
  });
}
