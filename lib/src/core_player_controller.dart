import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:core_video_player/src/contracts/iconnectivity.dart';
import 'package:core_video_player/src/contracts/ikeep_screen_on.dart';
import 'package:core_video_player/src/contracts/ivideo_player_controller.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';
import 'package:core_video_player/src/models/core_player_config.dart';
import 'package:core_video_player/src/models/core_player_controls_config.dart';
import 'package:core_video_player/src/models/core_player_controls_mode.dart';
import 'package:core_video_player/src/models/core_player_datasource.dart';
import 'package:core_video_player/src/models/core_player_debounce_action.dart';
import 'package:core_video_player/src/models/core_player_events.dart';
import 'package:core_video_player/src/models/core_player_icons.dart';
import 'package:core_video_player/src/models/core_player_resolution.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/utils/asserts.dart';
import 'package:core_video_player/src/utils/duration.dart';
import 'package:core_video_player/src/widgets/core_player_fullscreen.dart';
import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';
import 'package:video_player/video_player.dart';

class CorePlayerController extends ValueNotifier<CorePlayerState> with WidgetsBindingObserver {
  CorePlayerController._({
    required IVideoPlayerController videoController,
    CorePlayerEvents events = const CorePlayerEvents(),
    CorePlayerConfig config = const CorePlayerConfig(),
    CorePlayerState state = const CorePlayerState.uninitialized(),
    IConnectivity connectivity = const ConnectivityPlayer(),
    IKeepScreenOn keepScreenOn = const KeepScreenOnPlayer(),
    Platform platform = const LocalPlatform(),
  }) : _videoController = videoController,
       _events = events,
       _config = config,
       _connectivity = connectivity,
       _keepScreenOn = keepScreenOn,
       _platform = platform,
       super(state) {
    _onInit();
  }

  factory CorePlayerController.init({
    CorePlayerEvents events = const CorePlayerEvents(),
    CorePlayerConfig config = const CorePlayerConfig(),
    CorePlayerState state = const CorePlayerState.uninitialized(),
  }) {
    return CorePlayerController._(videoController: PlayerController(), events: events, config: config, state: state);
  }

  @visibleForTesting
  factory CorePlayerController.forTesting({
    CorePlayerEvents events = const CorePlayerEvents(),
    CorePlayerConfig config = const CorePlayerConfig(),
    CorePlayerState state = const CorePlayerState.uninitialized(),
    Platform platform = const LocalPlatform(),
    required IVideoPlayerController videoController,
    required IConnectivity connectivity,
    required IKeepScreenOn keepScreenOn,
  }) {
    return CorePlayerController._(
      videoController: videoController,
      events: events,
      config: config,
      state: state,
      platform: platform,
      connectivity: connectivity,
      keepScreenOn: keepScreenOn,
    );
  }

  Platform _platform;

  CorePlayerEvents _events;
  CorePlayerConfig _config;
  CorePlayerDatasource? datasource;

  IVideoPlayerController _videoController;
  IVideoPlayerController get videoController => _videoController;

  final IConnectivity _connectivity;
  final IKeepScreenOn _keepScreenOn;

  Floating? _floating;
  final _subscriptions = <StreamSubscription<dynamic>>[];

  bool _isPlayingBefore = false;
  bool _onBackgroundMode = false;
  bool changingDatasouce = false;
  Duration newPosition = Duration.zero;

  late final double _maxSpeed;
  final double _minSpeed = 0.5;

  List<ConnectivityResult>? _connectivityResult;
  RestartableTimer? _showControlsTimer;
  final Map<DebounceAction, Timer> _debounceTimers = {};

  CorePlayerControlsConfigFunction? onTapConfig;
  CorePlayerControlsConfigFunction? onTapSpeed;

  bool showTitle = true;
  bool showChromecastButton = true;

  /// Player lifecycle control
  /// -------------------------------------------------------------------------
  Future<void> _onInit() async {
    _maxSpeed = _platform.isIOS ? 2.0 : 4.0;

    WidgetsBinding.instance.addObserver(this);

    if (_platform.isAndroid) {
      unawaited(_verifyPip());
    }

    _subscriptions.add(_connectivity.onConnectivityChanged.listen(_checkConnection));
    await _connectivity.checkConnectivity().then(_checkConnection);
  }

  Future<void> _verifyPip() async {
    _floating = Floating();
    final isPipAvailable = await _floating?.isPipAvailable;
    value = value.copyWith(isPipSupported: isPipAvailable);
  }

  @override
  Future<void> dispose() async {
    await pause();
    await videoController.dispose();
    videoController.removeListener(_videoControllerListener);

    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();

    _showControlsTimer?.cancel();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        _onBackgroundMode = true;
        if (value.isPlaying) unawaited(_keepScreenOn.turnOff());
        if (value.isPlaying && _platform.isIOS) {
          Future.delayed(const Duration(milliseconds: 500), play);
        }
        break;
      case AppLifecycleState.detached:
        _onBackgroundMode = true;
        await pause();
        break;
      case AppLifecycleState.resumed:
        _onBackgroundMode = false;
        if (value.isPlaying) unawaited(_keepScreenOn.turnOn());
        unawaited(showControls());
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        _onBackgroundMode = true;
        if (value.isPlaying) unawaited(_keepScreenOn.turnOff());
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  /// Public methods to control the player
  /// -------------------------------------------------------------------------

  Future<void> changeDatasource([CorePlayerDatasource? source]) async {
    datasource = source ?? datasource;
    changingDatasouce = true;

    return _debounce(DebounceAction.datasource, () async {
      await videoController.dispose();
      videoController.removeListener(_videoControllerListener);

      value = value.copyWith(
        position: Duration.zero,
        duration: Duration.zero,
        isInitialized: false,
        isLoading: false,
        isFinished: false,
        subtitleText: '',
      );

      changingDatasouce = false;

      _events.onSetupDataSource?.call();

      if (_config.autoPlay && datasource != null && !_config.forceCloseInAutoPlay) {
        await play();
      }
    }, duration: const Duration(milliseconds: 800));
  }

  /// Starts video playback.
  ///
  /// If the video is not initialized yet, it will be initialized before
  /// playback starts.
  Future<void> play() async {
    if (!_enableInit) {
      return;
    }

    if (!value.isInitialized && !_config.forceCloseInAutoPlay) {
      await _initialize();
    }

    if (!value.isInitialized) {
      return;
    }

    if (!value.isPlaying && !_config.forceCloseInAutoPlay) {
      await videoController.play();
      _events.onPlay?.call(value);
    }

    if (!_onBackgroundMode) {
      /// Prevents the screen from turning off while the video is playing.
      unawaited(_keepScreenOn.turnOn());
    }

    await showControls();
  }

  /// Pauses video playback.
  Future<void> pause() async {
    if (value.isPlaying) {
      await videoController.pause();
      _events.onPause?.call(value);
    }

    if (!_onBackgroundMode) {
      /// Allows the screen to turn off while the video is paused.
      unawaited(_keepScreenOn.turnOff());
    }

    await showControls();
  }

  /// Calls the callback for the next video.
  Future<void> next() async {
    if (datasource?.hasNext != true || value.isLoading) {
      return;
    }

    if (_online && value.isInitialized) {
      value = value.copyWith(isLoading: true);
    }

    if (value.isPlaying) {
      await pause();
    }

    _events.onNext?.call(value);
  }

  /// Calls the callback for the previous video.
  Future<void> prev() async {
    if (datasource?.hasPrev != true || value.isLoading) {
      return;
    }

    if (_online && value.isInitialized) {
      value = value.copyWith(isLoading: true);
    }

    if (value.isPlaying) {
      await pause();
    }

    _events.onPrev?.call(value);
  }

  /// Shows the player controls.
  ///
  /// By default the controls are hidden again after 4 seconds.
  Future<void> showControls() async {
    if (_showControlsTimer?.isActive == true) {
      _showControlsTimer?.reset();
      return;
    }

    _showControlsTimer?.cancel();
    value = value.copyWith(showControls: true);
    _events.onControlsVisible?.call();

    _showControlsTimer = RestartableTimer(const Duration(seconds: 5), () {
      if (value.controlsMode.isAlwaysVisible || value.isBuffering || value.isLoading || value.cast.isConnect) {
        _showControlsTimer?.reset();
        return;
      }

      if (value.isPlaying) {
        hideControls();
      }
    });
  }

  /// Hides the player controls.
  void hideControls() {
    if (value.cast.isConnect) {
      return;
    }

    _showControlsTimer?.cancel();
    value = value.copyWith(showControls: false);
    _events.onControlsHidden?.call();
  }

  /// Changes the player controls display mode.
  void setControlsMode(CorePlayerControlsMode mode) {
    value = value.copyWith(controlsMode: mode);
  }

  /// Changes the player's auto-play setting.
  void setAutoPlay({required bool autoPlay}) {
    _config = _config.copyWith(autoPlay: autoPlay);
    _debounce(DebounceAction.autoPlay, () {
      _events.onChangedAutoPlay?.call(autoPlay);
    });
  }

  /// Changes the setting that prevents auto-play from resuming after being cancelled.
  void setCloseInAutoPlay({required bool closeInAutoPlay}) {
    _config = _config.copyWith(forceCloseInAutoPlay: closeInAutoPlay);
  }

  /// Changes the video playback speed.
  ///
  /// On iOS the playback speed must be between 0.5 and 2.0.
  /// On Android the playback speed must be between 0.5 and 4.0.
  void setSpeed(double speed) {
    if (speed < _minSpeed) {
      _events.onError?.call(
        '''A playback speed lower than $_minSpeed may cause issues with video playback''',
      );
    }
    if (speed > _maxSpeed) {
      _events.onError?.call(
        '''A playback speed higher than $_maxSpeed may cause issues with video playback''',
      );
    }

    value = value.copyWith(speed: speed);
    showControls();
    _debounce(DebounceAction.speed, () async {
      await videoController.setPlaybackSpeed(value.speed);
      _events.onChangedSpeed?.call(value.speed);
    });
  }

  /// Changes the video resolution.
  void setResolution(CorePlayerResolution resolution) {
    if (resolution == value.resolution) {
      return;
    }

    value = value.copyWith(resolution: resolution);
    _debounce(DebounceAction.resolution, () async {
      final oldState = value;
      if (oldState.isPlaying) {
        await pause();
      }

      final video = datasource?.resolutions[value.resolution];

      if (video == null) {
        _events.onError?.call('''Could not find the video for resolution ${value.resolution}''');
        return;
      }

      await videoController.dispose();
      videoController.removeListener(_videoControllerListener);

      final success = await _loadVideo(video);
      if (!success) {
        return;
      }

      if (oldState.isPlaying) {
        await play();
      }

      await seekTo(oldState.position);

      _events.onChangedResolution?.call(resolution);
    });
  }

  /// Toggles the player's fullscreen mode.
  ///
  /// If [forceTo] is provided, the player is forced to enter or exit
  /// fullscreen, otherwise the player toggles between modes.
  ///
  /// Entering fullscreen mode performs a navigation using the [Navigator].
  void toggleFullScreen(BuildContext context, {bool? forceTo, bool popScope = true}) {
    if (value.inPip || !value.isInitialized) {
      return;
    }
    showControls();

    final enterFullScreen = forceTo ?? !value.isFullscreen;

    if (enterFullScreen) {
      _enterOverlay(context, key: 'fullscreen');

      value = value.copyWith(isFullscreen: true);
      _events.onEnterFullscreen?.call();
      return;
    }
    _exitOverlay();

    value = value.copyWith(isFullscreen: false);
    _events.onExitFullscreen?.call();
  }

  /// Called only when the user taps the buttons to enter or exit fullscreen.
  void tapFullScreen() {
    if (value.isFullscreen) {
      _events.onTapExitFullscreen?.call();
    } else if (!value.isFullscreen) {
      _events.onTapEnterFullscreen?.call();
    }
  }

  /// Toggles the subtitles display.
  ///
  /// If [forceTo] is provided, the subtitles are forced to show or hide,
  /// otherwise they toggle between modes.
  void toggleSubtitle({bool? forceTo}) {
    value = value.copyWith(showSubtitles: forceTo ?? !value.showSubtitles);
    _events.onChangedSubtitles?.call(value.showSubtitles);
  }

  /// Seeks the video forward or backward to the given [position].
  ///
  /// If [position] is greater than the video duration, the video is seeked
  /// to the end.
  ///
  /// If [position] is less than 0, the video is seeked to the start.
  Future<void> seekTo(Duration position) async {
    if (value.isLoading) {
      return;
    }
    final keepGoing = _verifyConnectionBuffer(position: position);

    if (keepGoing) {
      return _updateNewPosition(position);
    }
  }

  /// Updates the video position from the ProgressBar.
  void progressUpdate(Duration position) {
    final keepGoing = _verifyConnectionBuffer(position: position);
    if (keepGoing) value.copyWith(position: position);
  }

  /// Fast-forwards the video by 10 seconds.
  Future<void> forward10() async {
    if (value.isLoading) {
      return;
    }

    value = value.copyWith(isSeeking: true, isNewPositioning: !value.isNewPositioning);
    if (_debounceTimers[DebounceAction.seek]?.isActive != true) {
      _isPlayingBefore = value.isPlaying;
      await videoController.pause();
      newPosition = value.position + const Duration(seconds: 10);
    } else {
      newPosition += const Duration(seconds: 10);
    }

    await _debounce(DebounceAction.seek, () async {
      final position = newPosition;
      final keepGoing = _verifyConnectionBuffer(position: position);
      if (keepGoing) {
        await _updateNewPosition(position);
      }
    }, duration: const Duration(seconds: 1));

    value = value.copyWith(isSeeking: false);
  }

  /// Rewinds the video by 10 seconds.
  Future<void> rewind10() async {
    if (value.isLoading) {
      return;
    }

    value = value.copyWith(isSeeking: true, isNewPositioning: !value.isNewPositioning);
    if (_debounceTimers[DebounceAction.seek]?.isActive != true) {
      _isPlayingBefore = value.isPlaying;
      await videoController.pause();
      newPosition = value.position - const Duration(seconds: 10);
    } else {
      newPosition -= const Duration(seconds: 10);
    }

    await _debounce(DebounceAction.seek, () async {
      final position = newPosition;
      final keepGoing = _verifyConnectionBuffer(position: position);
      if (keepGoing) {
        await _updateNewPosition(position);
      }
    }, duration: const Duration(seconds: 1));

    value = value.copyWith(isSeeking: false);
  }

  /// Starts picture-in-picture mode.
  ///
  /// Picture-in-picture mode is only available on Android.
  ///
  /// To avoid layout issues, the player enters fullscreen before entering
  /// picture-in-picture mode.
  void startPip([BuildContext? context]) {
    if (!value.isPipSupported) return;

    _debounce(DebounceAction.pip, () async {
      if (!value.isFullscreen) {
        if (context != null && assertState(context)) {
          _enterOverlay(context, key: 'pip');
        }
      }

      value = value.copyWith(controlsMode: CorePlayerControlsMode.alwaysHidden, inPip: true);
      _floating ??= Floating();

      await _floating!.enable(const ImmediatePiP());
      _listenPip();
    });
  }

  /// Calls the chromecast initialization callback.
  void onEnterChromecast() {
    showControls();
    _events.onEnterChromecast?.call();
  }

  /// Calls the chromecast exit callback.
  void onExitChromecast() {
    showControls();
    _events.onExitChromecast?.call();
  }

  /// Sets the chromecast display status to [CorePlayerCast.connecting].
  void connectingChromecast() {
    value = value.copyWith(cast: CorePlayerCast.connecting);
  }

  /// Sets the chromecast display status to [CorePlayerCast.connect].
  void startChromecast() {
    value = value.copyWith(cast: CorePlayerCast.connect);
    videoController.setVolume(0);
  }

  /// Sets the chromecast display status to [CorePlayerCast.disconnect].
  void stopChromecast() {
    value = value.copyWith(cast: CorePlayerCast.disconnect);
    videoController.setVolume(1);
  }

  /// Calls the player close callback.
  void close() {
    if (!value.isPlaying) {
      _keepScreenOn.turnOff();
    }
    _events.onClose?.call(value);
  }

  /// Cancels all pending debounce events of the player.
  void closeAllDebounce() {
    _debounceTimers.forEach((_, value) {
      value.cancel();
    });
  }

  /// Updates the player's event callbacks.
  // ignore: avoid_setters_without_getters
  set events(CorePlayerEvents events) {
    _events = events;
  }

  /// Accesses the player's configuration.
  CorePlayerConfig get config => _config;

  /// Returns the icons registered in [CorePlayerConfig].
  CorePlayerIcons get icons => _config.icons;

  /// Accesses the player controls configuration.
  CorePlayerControlsConfig get controlsConfig {
    final resolutions = datasource?.resolutions.keys.toList() ?? [];

    return CorePlayerControlsConfig(state: value, resolutions: resolutions, maxSpeed: _maxSpeed, minSpeed: _minSpeed);
  }

  /// Internal methods
  /// -------------------------------------------------------------------------

  void _listenPip() {
    _floating?.pipStatusStream.listen((status) {
      if (status == PiPStatus.unavailable) {
        return;
      }

      final enable = status == PiPStatus.enabled;
      if (enable) {
        _events.onPipStart?.call();
      } else {
        _floating = null;
        _exitOverlay();
        value = value.copyWith(isFullscreen: false);
        if (_onBackgroundMode) pause();
        _events.onPipStop?.call();
      }

      value = value.copyWith(
        inPip: enable,
        controlsMode: enable ? CorePlayerControlsMode.alwaysHidden : CorePlayerControlsMode.auto,
      );
    });
  }

  Future<void> _initialize() async {
    if (value.isInitialized) {
      return;
    }

    if (datasource == null) {
      _events.onError?.call('No data source was defined');
      return;
    }

    Uri? video;
    if (datasource!.resolutions.containsKey(value.resolution)) {
      video = datasource!.resolutions[value.resolution];
    } else {
      if (datasource!.resolutions.isNotEmpty) {
        video = datasource!.resolutions.values.first;
      }
    }

    if (video == null) {
      _events.onError?.call('Could not load the video');
      return;
    }

    final success = await _loadVideo(video);
    if (!success || _config.forceCloseInAutoPlay) {
      return;
    }

    if (datasource!.position != Duration.zero) {
      await seekTo(datasource!.position);
    }

    _events.onInitialized?.call(datasource!);
  }

  Future<void> _videoControllerListener() async {
    final buffered = Duration(
      seconds: videoController.value.buffered.isEmpty == false
          ? videoController.value.buffered[0].end.inSeconds - 1
          : 0,
    );
    final isBuffering = value.position > buffered && videoController.value.isBuffering == true;

    final position = videoController.value.position.round();

    if (position == buffered && !_online && !_isFile) {
      await pause();
      value = value.copyWith(
        isSeeking: true,
        isPlaying: false,
        isBuffering: true,
        controlsMode: value.controlsMode.isAlwaysHidden ? null : CorePlayerControlsMode.alwaysVisible,
      );
      return;
    }

    final oldState = value;
    value = value.copyWith(
      isInitialized: videoController.value.isInitialized == true,
      isPlaying: videoController.value.isPlaying == true,
      position: videoController.value.isPlaying == true && !oldState.isSeeking ? position : value.position,
      duration: videoController.value.duration.round(),
      buffered: buffered,
      isBuffering: (isBuffering && value.isPlaying && !_isFile) || value.isSeeking,
      isFinished:
          videoController.value.position.round() == videoController.value.duration.round() &&
          videoController.value.duration != Duration.zero,
      subtitleText: videoController.value.caption.text,
    );
    newPosition = value.position;

    if (oldState.position != value.position && value.position.inMilliseconds != 0) {
      _events.onProgress?.call(value);
    }

    if (buffered != Duration.zero) {
      _events.onBufferingUpdate?.call(buffered);
    }

    if (oldState.isFinished != value.isFinished && value.isFinished) {
      await showControls();
      await _events.onFinished?.call(value);
      if (_config.autoPlay && datasource?.hasNext == true) {
        await _events.onNext?.call(value);
      }
    }

    if ((!oldState.isPlaying && value.isPlaying && !value.isBuffering) ||
        (value.isPlaying && oldState.isBuffering && !value.isBuffering)) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setSpeed(value.speed);
      });
    }
  }

  Future<ClosedCaptionFile>? _getSubtitles() {
    final subtitle = datasource?.subtitle;
    if (subtitle == null) {
      return null;
    }

    if (subtitle.isScheme('file')) {
      return File.fromUri(subtitle)
          .readAsString()
          .then((fileContent) {
            if (subtitle.toString().endsWith('.vtt')) {
              return WebVTTCaptionFile(fileContent);
            }

            return SubRipCaptionFile(fileContent);
          })
          .catchError((_) => SubRipCaptionFile(''));
    }

    return http
        .get(subtitle, headers: datasource?.subtitleHeaders)
        .then((res) {
          if (res.headers['content-type']?.toLowerCase().contains('text/vtt') == true) {
            return WebVTTCaptionFile(utf8.decode(res.bodyBytes));
          }

          return SubRipCaptionFile(utf8.decode(res.bodyBytes));
        })
        .catchError((_) => SubRipCaptionFile(''));
  }

  Future<void> _checkConnection(List<ConnectivityResult> event) async {
    if (_connectivityResult == event) return;
    _connectivityResult = event;
    if (event.contains(ConnectivityResult.none)) {
      _disableChromecast();
      return;
    }
    _enableChromecast();
    if (!value.isPlaying && !value.isBuffering) return;
    if (value.cast == CorePlayerCast.connect) {
      _events.onReconnectChromecast?.call();
    }

    final keepGoing = _verifyConnectionBuffer(position: value.position, verifyOnline: false);
    if (keepGoing) return;

    value = value.copyWith(isLoading: true);
    await pause();
    await _retryDatasource();
    await play();
  }

  Future<void> _retryDatasource() async {
    await videoController.dispose();
    videoController.removeListener(_videoControllerListener);

    value = value.copyWith(
      isInitialized: false,
      controlsMode: value.controlsMode.isAlwaysHidden ? null : CorePlayerControlsMode.auto,
      subtitleText: '',
      isLoading: false,
    );

    datasource = datasource?.copyWith(position: value.position);
  }

  bool _verifyConnectionBuffer({required Duration position, bool verifyOnline = true}) {
    if (_online && verifyOnline) return true;

    if (_isFile) return true;

    return _bufferZero(position: position);
  }

  bool _bufferZero({required Duration position}) {
    final bufferZero = DurationRange(Duration.zero, Duration.zero);
    final buffered = videoController.value.buffered.firstWhere(
      (buf) => buf.start <= position && buf.end > position,
      orElse: () => bufferZero,
    );
    final videoPosition = videoController.value.position;

    if (buffered != bufferZero && !value.isBuffering) return true;

    if (position > videoPosition && !value.isBuffering) return true;

    return false;
  }

  Future<void> _updateNewPosition(Duration position) async {
    value = value.copyWith(isSeeking: true);

    newPosition = position.clamp(Duration.zero, value.duration);

    value = value.copyWith(position: newPosition);

    await showControls();
    _events.onSeek?.call(newPosition, value);
    await videoController.seekTo(newPosition);

    if (_isPlayingBefore) {
      await videoController.play();
      value = value.copyWith(isSeeking: false, isBuffering: value.isBuffering);
    }

    if (!_isPlayingBefore) {
      value = value.copyWith(isSeeking: false, isBuffering: false);
    }
  }

  Future<bool> _loadVideo(Uri videoUri, {bool? toggleViewType = false}) async {
    value = value.copyWith(
      isLoading: true,
      controlsMode: value.controlsMode.isAlwaysHidden ? null : CorePlayerControlsMode.auto,
    );

    final closedCaptionFile = _getSubtitles();
    final videoPlayerOptions = VideoPlayerOptions(allowBackgroundPlayback: true);

    if (videoUri.scheme.isEmpty) {
      _events.onError?.call('Video URI not defined.');
      value = value.copyWith(isLoading: false);
      return false;
    }

    _videoController = videoController.create(
      dataSource: videoUri,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      toggleViewType: toggleViewType,
    )..addListener(_videoControllerListener);

    try {
      await _videoController.initialize();
    } catch (e, stacktrace) {
      if (toggleViewType == false) {
        return await _loadVideo(videoUri, toggleViewType: true);
      }
      await dispose();
      _events.onError?.call('Failed to initialize the video.', stacktrace);
      value = value.copyWith(isLoading: false);
      return false;
    }

    await videoController.seekTo(value.position);

    if (videoController.value.isInitialized != true) {
      _events.onError?.call('Could not initialize the video.');
      value = value.copyWith(isLoading: false);
      return false;
    }

    if (value.cast == CorePlayerCast.connect) {
      await videoController.setVolume(0);
    }

    value = value.copyWith(isLoading: false);
    return true;
  }

  Future<void> _debounce(
    DebounceAction action,
    FutureOr<void> Function() callback, {
    Duration duration = const Duration(milliseconds: 500),
    FutureOr<void>? Function()? waitFunction,
  }) async {
    final completer = Completer<void>();

    _debounceTimers[action]?.cancel();

    if (waitFunction == null) {
      _debounceTimers[action] = Timer(duration, () => completer.complete(callback()));
    } else {
      await waitFunction.call();
      _debounceTimers[action] = Timer(duration, () => completer.complete(callback()));
    }

    return completer.future;
  }

  bool get _online => !(_connectivityResult?.contains(ConnectivityResult.none) ?? true);

  bool get _isFile => datasource?.resolutions[value.resolution]?.isScheme('file') == true;

  bool get _enableInit => _debounceTimers[DebounceAction.datasource]?.isActive != true && !changingDatasouce;

  /// Sets the chromecast display status to [CorePlayerCast.unavailable].
  void _disableChromecast() {
    value = value.copyWith(cast: CorePlayerCast.unavailable);
  }

  /// Sets the chromecast display status to [CorePlayerCast.disconnect], the default value.
  void _enableChromecast() {
    value = value.copyWith(cast: CorePlayerCast.disconnect);
  }

  OverlayEntry? _overlayEntry;
  OverlayState? _overlayState;

  void _enterOverlay(BuildContext context, {required String key}) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (_) => CorePlayerFullscreen(this, key: Key(key)));
    }
    try {
      if (_overlayEntry != null) {
        _overlayState = Overlay.of(context);
        _overlayState?.insert(_overlayEntry!);
      }
    } catch (e) {
      debugPrint('Error inserting overlay: $e');
    }
  }

  void _exitOverlay() {
    if (_overlayEntry != null) {
      try {
        if (_overlayState != null) {
          _overlayEntry?.remove();
        }
      } catch (e) {
        debugPrint('Error removing overlay: $e');
      }
    }
    _overlayEntry = null;
    _overlayState = null;
  }
}
