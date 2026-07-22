import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';

void main() {
  test('CorePlayerState', () {
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
    expect(playerState, isA<CorePlayerState>());
  });

  test('CorePlayerState.uninitialized', () {
    const playerState = CorePlayerState.uninitialized();
    expect(playerState, isA<CorePlayerState>());
  });

  test('CorePlayerState.copyWith', () {
    var playerState = const CorePlayerState.uninitialized();
    expect(playerState.isInitialized, false);

    playerState = playerState.copyWith(isInitialized: true);
    expect(playerState.isInitialized, true);
  });

  test('CorePlayerState.toString', () {
    const playerState = CorePlayerState.uninitialized();
    expect(playerState.toString(), isA<String>());
  });

  test('CorePlayerState.hashCode', () {
    const playerState = CorePlayerState.uninitialized();
    expect(playerState.hashCode, isA<int>());
  });
}
