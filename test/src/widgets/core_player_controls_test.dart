import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';

import '../mocks/mock_iconnectivity.dart';
import '../mocks/mock_ikeep_screen_on.dart';
import '../mocks/mock_ivideo_player_controller.dart';

void main() {
  late CorePlayerController corePlayerController;
  late CorePlayerEvents corePlayerEvents;
  const title = 'Sample title';
  late CorePlayerDatasource datasource;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    datasource = CorePlayerDatasource(
      title: title,
      description: 'Sample description',
      hasNext: true,
      hasPrev: true,
      resolutions: {CorePlayerResolution.p480: Uri(scheme: 'http')},
      banner: Uri(scheme: 'file', path: ''),
    );
    corePlayerEvents = const CorePlayerEvents();
    corePlayerController = CorePlayerController.forTesting(
      videoController: MockPlayerController(),
      connectivity: MockIConnectivity(),
      keepScreenOn: MockKeepScreenOn(),
      events: corePlayerEvents,
      state: const CorePlayerState.uninitialized().copyWith(showControls: true),
    )..datasource = datasource;
  });

  tearDown(() {
    corePlayerController = CorePlayerController.forTesting(
      videoController: MockPlayerController(),
      connectivity: MockIConnectivity(),
      keepScreenOn: MockKeepScreenOn(),
      events: corePlayerEvents,
      state: const CorePlayerState.uninitialized().copyWith(showControls: true),
    )..datasource = datasource;
  });

  Future<void> loadCorePlayer(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: Scaffold(body: CorePlayer(corePlayerController))));
    await widgetTester.pumpAndSettle(const Duration(seconds: 4));
  }

  group('Should validate the player control actions', () {
    testWidgets('Should enter fullscreen when tapping the fullscreen button', (widgetTester) async {
      await loadCorePlayer(widgetTester);

      final playButton = find.byKey(const Key('tap-play-video'));

      expect(playButton, findsOneWidget);

      await widgetTester.runAsync(() => widgetTester.tap(playButton));

      await widgetTester.pump();

      expect(corePlayerController.value.isFullscreen, false);

      final fullscreenButton = find.byKey(const Key('tap-fullscreen-player'));

      expect(fullscreenButton, findsOneWidget);

      await widgetTester.runAsync(() => widgetTester.tap(fullscreenButton));

      await widgetTester.pump();

      expect(corePlayerController.value.isFullscreen, true);
    });
  });
}
