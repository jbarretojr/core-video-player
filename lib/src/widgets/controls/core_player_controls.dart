import 'package:flutter/material.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/controls/core_player_chromecast.dart';
import 'package:core_video_player/src/widgets/controls/core_player_close.dart';
import 'package:core_video_player/src/widgets/controls/core_player_config.dart';
import 'package:core_video_player/src/widgets/controls/core_player_duration.dart';
import 'package:core_video_player/src/widgets/controls/core_player_forward.dart';
import 'package:core_video_player/src/widgets/controls/core_player_fullscreen.dart';
import 'package:core_video_player/src/widgets/controls/core_player_next.dart';
import 'package:core_video_player/src/widgets/controls/core_player_pip.dart';
import 'package:core_video_player/src/widgets/controls/core_player_play_pause.dart';
import 'package:core_video_player/src/widgets/controls/core_player_prev.dart';
import 'package:core_video_player/src/widgets/controls/core_player_progress.dart';
import 'package:core_video_player/src/widgets/controls/core_player_rewind.dart';
import 'package:core_video_player/src/widgets/controls/core_player_speed.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerControls extends CorePlayerWidget {
  const CorePlayerControls(super.controller, {super.key});

  @override
  State<CorePlayerControls> createState() => _CorePlayerControlsState();
}

class _CorePlayerControlsState extends CorePlayerWidgetState<CorePlayerControls> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.showControls != newState.showControls ||
        oldState.controlsMode != newState.controlsMode ||
        oldState.isFullscreen != newState.isFullscreen ||
        oldState.cast != newState.cast;
  }

  @override
  Widget build(BuildContext context) {
    return state.showControls && !state.controlsMode.isAlwaysHidden ? controls(context) : empty();
  }

  Widget controls(BuildContext context) {
    final isPipAvailable = state.cast.isDisconnect || state.cast.isUnavailable;
    final isFullscreenAvailable = state.cast.isDisconnect || state.cast.isUnavailable;
    final isChromecaseAvailable = !state.cast.isUnavailable && widget.controller.showChromecastButton;

    return InkWell(
      onTap: widget.controller.hideControls,
      child: ColoredBox(
        color: Colors.black.withValues(alpha: .7),
        child: Padding(
          padding: state.isFullscreen ? const EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CorePlayerPrev(widget.controller),
                    CorePlayerRewind(widget.controller),
                    const SizedBox(width: 16),
                    CorePlayerPlayPause(widget.controller),
                    const SizedBox(width: 16),
                    CorePlayerForward(widget.controller),
                    CorePlayerNext(widget.controller),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      if (widget.controller.showTitle)
                        Expanded(child: CorePlayerClose(widget.controller))
                      else
                        const Spacer(),
                      const SizedBox(width: 16),
                      CorePlayerSpeed(widget.controller),
                      CorePlayerConfig(widget.controller),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      CorePlayerDuration(widget.controller),
                      const Spacer(),
                      if (isPipAvailable) CorePlayerPip(widget.controller),
                      if (isChromecaseAvailable) CorePlayerChromecast(widget.controller),
                      if (isFullscreenAvailable) CorePlayerFullscreen(widget.controller),
                    ],
                  ),
                  CorePlayerProgress(widget.controller),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget empty() {
    return Semantics(
      label: 'Show video controls',
      child: InkWell(
        onTap: widget.controller.showControls,
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
