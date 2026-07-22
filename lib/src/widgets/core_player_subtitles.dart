import 'package:flutter/material.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerSubtitles extends CorePlayerWidget {
  const CorePlayerSubtitles(super.controller, {super.key});

  @override
  State<CorePlayerSubtitles> createState() => _CorePlayerSubtitlesState();
}

class _CorePlayerSubtitlesState extends CorePlayerWidgetState<CorePlayerSubtitles> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.showSubtitles != newState.showSubtitles ||
        oldState.subtitleText != newState.subtitleText ||
        oldState.controlsMode != newState.controlsMode;
  }

  @override
  Widget build(BuildContext context) {
    if (!state.showSubtitles || state.subtitleText.isEmpty || state.controlsMode.isAlwaysHidden) {
      return const SizedBox();
    }

    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Text(
        state.subtitleText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          backgroundColor: Colors.black45,
          shadows: [
            Shadow(offset: Offset(1, 1)),
            Shadow(offset: Offset(-1, 1)),
            Shadow(offset: Offset(1, -1)),
            Shadow(offset: Offset(-1, -1)),
          ],
        ),
      ),
    );
  }
}
