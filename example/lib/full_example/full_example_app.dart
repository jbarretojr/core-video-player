import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_video_player/core_video_player.dart';

import 'lesson.dart';
import 'widgets/lesson_list_tile.dart';
import 'widgets/mini_player_bar.dart';
import 'widgets/player_settings_sheet.dart';
import 'widgets/player_speed_sheet.dart';

void main() => runApp(const MaterialApp(home: FullExamplePage()));

/// A more complete usage of [CorePlayer]: a lesson playlist with
/// next/previous navigation, a collapsible miniplayer and fullscreen that
/// follows the device's physical rotation.
class FullExamplePage extends StatefulWidget {
  const FullExamplePage({super.key});

  @override
  State<FullExamplePage> createState() => _FullExamplePageState();
}

class _FullExamplePageState extends State<FullExamplePage> {
  late final CorePlayerController _playerController;

  final List<Lesson> _lessons = sampleLessons;
  int? _currentIndex;
  bool _isMiniplayer = false;
  bool _autoRotateEnabled = true;
  Orientation? _lastOrientation;

  Lesson? get _currentLesson => _currentIndex == null ? null : _lessons[_currentIndex!];

  @override
  void initState() {
    super.initState();
    _playerController = CorePlayerController.init(
      config: const CorePlayerConfig(autoPlay: true),
      events: CorePlayerEvents(
        onNext: (_) => _goToRelative(1),
        onPrev: (_) => _goToRelative(-1),
        onFinished: (_) {
          if (_playerController.config.autoPlay) _goToRelative(1);
        },
        onClose: (_) => setState(() => _isMiniplayer = true),
        onEnterFullscreen: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
        onExitFullscreen: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
        onTapEnterFullscreen: () => _forceOrientation(landscape: true),
        onTapExitFullscreen: () => _forceOrientation(landscape: false),
        onError: (message, [trace]) => _showMessage(message),
      ),
    );
  }

  @override
  void dispose() {
    _playerController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  /// Nudges the OS towards the requested orientation, then frees up all
  /// orientations again so physical rotation keeps driving [_handleOrientationChanged].
  Future<void> _forceOrientation({required bool landscape}) async {
    await SystemChrome.setPreferredOrientations(
      landscape ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight] : [DeviceOrientation.portraitUp],
    );

    if (!_autoRotateEnabled) return;
    await Future.delayed(const Duration(milliseconds: 400));
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  void _handleOrientationChanged(Orientation orientation) {
    if (!_autoRotateEnabled || _isMiniplayer) return;

    final state = _playerController.value;
    if (!state.isInitialized) return;

    if (orientation == Orientation.landscape && !state.isFullscreen) {
      _playerController.toggleFullScreen(context, forceTo: true);
    } else if (orientation == Orientation.portrait && state.isFullscreen) {
      _playerController.toggleFullScreen(context, forceTo: false);
    }
  }

  Future<void> _loadLesson(int index) async {
    final lesson = _lessons[index];
    setState(() {
      _currentIndex = index;
      _isMiniplayer = false;
    });

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    await _playerController.changeDatasource(
      CorePlayerDatasource(
        title: lesson.title,
        description: lesson.description,
        banner: lesson.banner,
        hasNext: index < _lessons.length - 1,
        hasPrev: index > 0,
        resolutions: lesson.resolutions,
      ),
    );
  }

  void _goToRelative(int delta) {
    if (_currentIndex == null) return;
    final newIndex = _currentIndex! + delta;
    if (newIndex < 0 || newIndex >= _lessons.length) return;
    _loadLesson(newIndex);
  }

  Future<void> _closeMiniplayer() async {
    await _playerController.pause();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    setState(() {
      _isMiniplayer = false;
      _currentIndex = null;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openSettingsSheet(CorePlayerControlsConfig config) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => PlayerSettingsSheet(
            controller: _playerController,
            config: config,
            autoRotateEnabled: _autoRotateEnabled,
            onChangeAutoRotate: (value) => setState(() => _autoRotateEnabled = value),
          ),
    );
  }

  void _openSpeedSheet(CorePlayerControlsConfig config) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PlayerSpeedSheet(controller: _playerController, config: config),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    if (_lastOrientation != orientation) {
      _lastOrientation = orientation;
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleOrientationChanged(orientation));
    }

    return ValueListenableBuilder<CorePlayerState>(
      valueListenable: _playerController,
      builder: (context, state, _) {
        return Scaffold(
          appBar: state.isFullscreen ? null : AppBar(title: const Text('Full example')),
          body: Stack(
            children: [
              Column(
                children: [
                  if (!_isMiniplayer && _currentLesson != null) ...[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CorePlayer(
                        _playerController,
                        onTapConfig: _openSettingsSheet,
                        onTapSpeed: _openSpeedSheet,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_currentLesson!.title, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(_currentLesson!.description),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: _isMiniplayer ? 72 : 0),
                      itemCount: _lessons.length,
                      itemBuilder:
                          (context, index) => LessonListTile(
                            lesson: _lessons[index],
                            selected: index == _currentIndex,
                            onTap: () => _loadLesson(index),
                          ),
                    ),
                  ),
                ],
              ),
              if (_isMiniplayer && _currentLesson != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayerBar(
                    controller: _playerController,
                    lesson: _currentLesson!,
                    onTap: () => setState(() => _isMiniplayer = false),
                    onClose: _closeMiniplayer,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
