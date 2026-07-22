import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';

void main() {
  test('CorePlayerControlsConfig', () {
    const controlsConfig = CorePlayerControlsConfig(
      state: CorePlayerState(
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
      ),
      resolutions: CorePlayerResolution.values,
      maxSpeed: 2,
      minSpeed: 0.75,
    );

    expect(controlsConfig, isA<CorePlayerControlsConfig>());
    expect(controlsConfig.state, isA<CorePlayerState>());
    expect(controlsConfig.resolutions, isA<List<CorePlayerResolution>>());
    expect(controlsConfig.resolutions.length, equals(5));
    expect(controlsConfig.maxSpeed, equals(2.0));
    expect(controlsConfig.minSpeed, equals(0.75));
  });
}
