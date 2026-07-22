import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:core_video_player/src/models/core_player_controls_mode.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/utils/duration.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerProgress extends CorePlayerWidget {
  const CorePlayerProgress(super.controller, {super.key});

  @override
  State<CorePlayerProgress> createState() => _CorePlayerProgressState();
}

class _CorePlayerProgressState extends CorePlayerWidgetState<CorePlayerProgress> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.position != newState.position ||
        oldState.duration != newState.duration ||
        oldState.buffered != newState.buffered ||
        oldState.isFullscreen != newState.isFullscreen;
  }

  @override
  Widget build(BuildContext context) {
    final progressWidget = ProgressBar(
      key: const Key('progress-bar-player'),
      progress: widget.controller.newPosition,
      buffered: state.buffered,
      total: state.duration,
      timeLabelLocation: TimeLabelLocation.none,
      progressBarColor: const Color.fromRGBO(0, 103, 255, 1),
      thumbColor: const Color.fromRGBO(0, 103, 255, 1),
      thumbRadius: 11,
      thumbCanPaintOutsideBar: false,
      baseBarColor: Colors.white24,
      bufferedBarColor: Colors.white24,
      barHeight: 8,
      barCapShape: BarCapShape.square,
      onSeek: (value) => widget.controller.seekTo(value),
      onDragStart: (_) => widget.controller.setControlsMode(CorePlayerControlsMode.alwaysVisible),
      onDragEnd: () => widget.controller.setControlsMode(CorePlayerControlsMode.auto),
      onDragUpdate: (v) => widget.controller.progressUpdate(v.timeStamp.round()),
    );

    if (state.isFullscreen) {
      return Padding(padding: const EdgeInsets.only(bottom: 16), child: progressWidget);
    }

    return Transform(transform: Matrix4.translationValues(0, 5, 0), child: progressWidget);
  }
}
