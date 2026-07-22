import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';
import 'package:core_video_player/src/utils/duration.dart';
import 'package:platform/platform.dart';

import 'mocks/mock_iconnectivity.dart';
import 'mocks/mock_ikeep_screen_on.dart';
import 'mocks/mock_ivideo_player_controller.dart';

void main() {
  late CorePlayerController corePlayerController;
  late CorePlayerEvents corePlayerEvents;
  const title = 'Sample title';
  late CorePlayerDatasource datasource;

  const channel = MethodChannel('floating');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'pipAvailable':
          return true;
        case 'inPipAlready':
          return true;
        case 'enablePip':
          return true;
      }

      return null;
    });

    datasource = CorePlayerDatasource(
      title: title,
      description: 'Sample description',
      hasNext: true,
      hasPrev: true,
      resolutions: {CorePlayerResolution.p480: Uri(scheme: 'http')},
    );
    corePlayerEvents = const CorePlayerEvents();
  });

  setUp(() {
    corePlayerController = CorePlayerController.forTesting(
      videoController: MockPlayerController(),
      connectivity: MockIConnectivity(),
      keepScreenOn: MockKeepScreenOn(),
      events: corePlayerEvents,
      platform: FakePlatform(operatingSystem: 'android'),
      state: const CorePlayerState.uninitialized().copyWith(isPipSupported: true),
    )..datasource = datasource;
  });

  test('Instance', () {
    expect(corePlayerController, isA<CorePlayerController>());
  });

  group('Video controls', () {
    setUp(() {
      corePlayerController = CorePlayerController.forTesting(
        videoController: MockPlayerController(),
        connectivity: MockIConnectivity(),
        keepScreenOn: MockKeepScreenOn(),
        events: corePlayerEvents,
        platform: FakePlatform(operatingSystem: 'android'),
        state: const CorePlayerState.uninitialized().copyWith(isPipSupported: true),
      )..datasource = datasource;
    });

    test('Should forward 30 seconds in the player', () async {
      corePlayerController.value = corePlayerController.value.copyWith(duration: const Duration(minutes: 45));
      await corePlayerController.forward10();
      await corePlayerController.forward10();
      await corePlayerController.forward10();
      expect(corePlayerController.value.position, const Duration(seconds: 30));
    });

    test('Should rewind 30 seconds in the player', () async {
      corePlayerController.value = corePlayerController.value.copyWith(
        duration: const Duration(minutes: 45),
        position: const Duration(seconds: 30),
      );
      expect(corePlayerController.value.position, const Duration(seconds: 30));
      await corePlayerController.rewind10();
      await corePlayerController.rewind10();
      await corePlayerController.rewind10();
      expect(corePlayerController.value.position, Duration.zero);
    });

    test('Should seek directly to 2 minutes in the player', () async {
      corePlayerController.value = corePlayerController.value.copyWith(duration: const Duration(minutes: 45));

      await corePlayerController.seekTo(const Duration(minutes: 2));
      expect(corePlayerController.value.position, const Duration(minutes: 2));
    });

    test('Should start the player', () async {
      expect(corePlayerController.value.isInitialized, false);

      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);
      expect(corePlayerController.value.isInitialized, true);
    });

    test('Should switch to pause in the player', () async {
      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);

      await corePlayerController.pause();
      await delay(200);
      expect(corePlayerController.value.isPlaying, false);
    });

    test('Should resume the video after pausing', () async {
      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);

      await corePlayerController.pause();
      await delay(200);
      expect(corePlayerController.value.isPlaying, false);

      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);
    });

    test('Should switch to the next video', () async {
      expect(corePlayerController.value.isLoading, false);

      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);

      await corePlayerController.next();
      await delay(200);
      expect(corePlayerController.value.isPlaying, false);
      expect(corePlayerController.value.isLoading, true);
    });

    test('Should switch to the previous video', () async {
      expect(corePlayerController.value.isLoading, false);

      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);

      await corePlayerController.prev();
      await delay(200);
      expect(corePlayerController.value.isPlaying, false);
      expect(corePlayerController.value.isLoading, true);
    });

    test('Should show the video controls', () async {
      expect(corePlayerController.value.showControls, false);

      await corePlayerController.showControls();
      expect(corePlayerController.value.showControls, true);
    });

    test('Should hide the video controls', () async {
      expect(corePlayerController.value.showControls, false);

      await corePlayerController.showControls();
      expect(corePlayerController.value.showControls, true);

      corePlayerController.hideControls();
      expect(corePlayerController.value.showControls, false);
    });

    test('Should change the player auto-play setting', () async {
      expect(corePlayerController.config.autoPlay, false);

      corePlayerController.setAutoPlay(autoPlay: true);
      expect(corePlayerController.config.autoPlay, true);
    });

    test('Should change the video playback speed', () async {
      expect(corePlayerController.value.speed, 1.0);

      corePlayerController.setSpeed(2);
      expect(corePlayerController.value.speed, 2.0);
    });

    test('Should change the video resolution', () async {
      expect(corePlayerController.value.resolution, CorePlayerResolution.p480);

      corePlayerController.setResolution(CorePlayerResolution.p720);
      expect(corePlayerController.value.resolution, CorePlayerResolution.p720);
    });

    test('Should enable the video subtitles', () async {
      expect(corePlayerController.value.showSubtitles, true);

      corePlayerController.toggleSubtitle();
      expect(corePlayerController.value.showSubtitles, false);
    });

    test('Should validate switching the datasource', () async {
      expect(corePlayerController.datasource?.title, title);
      const testTitle = 'Test 2';

      await corePlayerController.changeDatasource(datasource.copyWith(title: testTitle));
      expect(corePlayerController.datasource?.title, testTitle);
    });

    test('Should validate a double access to the datasource', () async {
      const testTitle = 'Test 2';

      unawaited(corePlayerController.changeDatasource(datasource));

      unawaited(corePlayerController.changeDatasource(datasource.copyWith(title: testTitle)));

      expect(corePlayerController.datasource?.title, testTitle);
    });

    test('Should validate disposing the player', () async {
      await corePlayerController.play();
      await delay(200);
      expect(corePlayerController.value.isPlaying, true);

      await corePlayerController.dispose();
      await delay(200);
      expect(corePlayerController.value.isPlaying, false);
    });
  });

  test('setVideoController test', () {
    expect(corePlayerController.videoController, isA<MockPlayerController>());
  });

  group('Chromecast', () {
    test('stopChromecast test', () {
      corePlayerController.stopChromecast();
      expect(corePlayerController.value, isA<CorePlayerState>());
      expect(corePlayerController.value.cast, CorePlayerCast.disconnect);
    });

    test('startChromecast test', () {
      corePlayerController.startChromecast();
      expect(corePlayerController.value, isA<CorePlayerState>());
      expect(corePlayerController.value.cast, CorePlayerCast.connect);
    });

    test('connectingChromecast test', () {
      corePlayerController.connectingChromecast();
      expect(corePlayerController.value, isA<CorePlayerState>());
      expect(corePlayerController.value.cast, CorePlayerCast.connecting);
    });

    test('onExitChromecast test', () {
      corePlayerController.onExitChromecast();
      expect(corePlayerEvents.onExitChromecast, null);
    });

    test('onEnterChromecast test', () {
      corePlayerController.onEnterChromecast();
      expect(corePlayerEvents.onEnterChromecast, null);
    });
  });

  group('Picture in Picture', () {
    test('Should hide the controls and enable inPip when pip is activated', () async {
      corePlayerController.startPip();
      await Future.delayed(const Duration(milliseconds: 500), () {
        expect(corePlayerController.value.controlsMode, CorePlayerControlsMode.alwaysHidden);
        expect(corePlayerController.value.inPip, true);
      });
    });
  });

  test('changeDatasource should wait for the debounce to run', () async {
    corePlayerController.setAutoPlay(autoPlay: false);
    await corePlayerController.play();
    await delay(200);
    expect(corePlayerController.value.isInitialized, true);

    await corePlayerController.changeDatasource(datasource);
    await delay(200);
    expect(corePlayerController.value.isInitialized, false);
  });

  test('an invalid datasource should not start the video', () async {
    corePlayerController.datasource = CorePlayerDatasource(
      title: title,
      description: 'Sample description',
      hasNext: true,
      hasPrev: true,
      resolutions: {CorePlayerResolution.p480: Uri()},
    );

    expect(corePlayerController.value.isInitialized, false);
    await corePlayerController.play();
    expect(corePlayerController.value.isInitialized, false);
  });
}
