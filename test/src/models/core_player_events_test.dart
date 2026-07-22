import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';

void main() {
  test('CorePlayerEvents', () {
    const events = CorePlayerEvents();
    expect(events, isA<CorePlayerEvents>());
  });

  test('CorePlayerEvents check default', () {
    const events = CorePlayerEvents();
    expect(events.onInitialized, isNull);
    expect(events.onPlay, isNull);
    expect(events.onPause, isNull);
    expect(events.onProgress, isNull);
    expect(events.onSeek, isNull);
    expect(events.onNext, isNull);
    expect(events.onPrev, isNull);
    expect(events.onFinished, isNull);
    expect(events.onChangedAutoPlay, isNull);
    expect(events.onEnterFullscreen, isNull);
    expect(events.onExitFullscreen, isNull);
    expect(events.onTapEnterFullscreen, isNull);
    expect(events.onTapExitFullscreen, isNull);
    expect(events.onEnterChromecast, isNull);
    expect(events.onExitChromecast, isNull);
    expect(events.onReconnectChromecast, isNull);
    expect(events.onControlsVisible, isNull);
    expect(events.onControlsHidden, isNull);
    expect(events.onChangedSpeed, isNull);
    expect(events.onChangedSubtitles, isNull);
    expect(events.onChangedResolution, isNull);
    expect(events.onPipStart, isNull);
    expect(events.onPipStop, isNull);
    expect(events.onSetupDataSource, isNull);
    expect(events.onBufferingUpdate, isNull);
    expect(events.onClose, isNull);
    expect(events.onError, isNull);
  });
}
