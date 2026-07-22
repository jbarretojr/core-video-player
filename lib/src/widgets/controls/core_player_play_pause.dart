import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerPlayPause extends CorePlayerWidget {
  const CorePlayerPlayPause(super.controller, {super.key});

  @override
  State<CorePlayerPlayPause> createState() => _CorePlayerPlayPauseState();
}

class _CorePlayerPlayPauseState extends CorePlayerWidgetState<CorePlayerPlayPause> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.isLoading != newState.isLoading ||
        oldState.isBuffering != newState.isBuffering ||
        oldState.isPlaying != newState.isPlaying ||
        oldState.isSeeking != newState.isSeeking ||
        oldState.isFinished != newState.isFinished;
  }

  @override
  Widget build(BuildContext context) {
    String? label = 'Loading';
    VoidCallback? onPressed;
    IconData? icon;
    double? size;
    Color? color;

    if (state.isPlaying) {
      label = 'Pause video';
      onPressed = widget.controller.pause;
      icon = widget.controller.icons.pause.icon;
      size = widget.controller.icons.pause.size;
      color = widget.controller.icons.pause.color;
    }

    if (!state.isPlaying) {
      label = 'Resume video';
      widget.controller.changingDatasouce = false;
      widget.controller.setCloseInAutoPlay(closeInAutoPlay: false);
      onPressed = widget.controller.play;
      icon = widget.controller.icons.play_arrow.icon;
      size = widget.controller.icons.play_arrow.size;
      color = widget.controller.icons.play_arrow.color;
    }

    if (state.isFinished) {
      label = 'Restart video';
      onPressed = () async {
        await widget.controller.seekTo(Duration.zero);
        await widget.controller.play();
      };

      icon = widget.controller.icons.rotate_right.icon;
      size = widget.controller.icons.rotate_right.size;
      color = widget.controller.icons.rotate_right.color;
    }

    return Semantics(
      label: label,
      sortKey: const OrdinalSortKey(7),
      button: true,
      excludeSemantics: true,
      child: state.isSeeking || state.isLoading || state.isBuffering
          ? const Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: Colors.white)),
            )
          : IconButton(
              key: const Key('tap-play-pause-player'),
              onPressed: onPressed,
              icon: Icon(icon),
              color: color,
              iconSize: size,
            ),
    );
  }
}
