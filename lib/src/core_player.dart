import 'package:flutter/material.dart';
import 'package:core_video_player/src/models/core_player_controls_config.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/controls/core_player_blur.dart';
import 'package:core_video_player/src/widgets/controls/core_player_controls.dart';
import 'package:core_video_player/src/widgets/core_player_banner.dart';
import 'package:core_video_player/src/widgets/core_player_subtitles.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';
import 'package:video_player/video_player.dart';

class CorePlayer extends CorePlayerWidget {
  CorePlayer(
    super.controller, {
    CorePlayerControlsConfigFunction? onTapConfig,
    CorePlayerControlsConfigFunction? onTapSpeed,
    bool? showTitle,
    bool? showChromecastButton,
    super.key,
  }) {
    controller
      ..onTapConfig = onTapConfig
      ..onTapSpeed = onTapSpeed
      ..showTitle = showTitle ?? true
      ..showChromecastButton = showChromecastButton ?? true;
  }

  @override
  State<CorePlayer> createState() => _CorePlayerState();
}

class _CorePlayerState extends CorePlayerWidgetState<CorePlayer> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.isLoading != newState.isLoading ||
        oldState.isInitialized != newState.isInitialized ||
        oldState.resolution != newState.resolution ||
        oldState.cast != newState.cast;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: state.isInitialized || state.isLoading
          ? Stack(
              children: [
                if (!state.isLoading && !state.cast.isConnect) ...[
                  Builder(
                    builder: (context) {
                      final controller = widget.controller.videoController.controller;
                      if (controller is VideoPlayerController) {
                        return VideoPlayer(controller);
                      }

                      return const SizedBox();
                    },
                  ),
                  CorePlayerSubtitles(widget.controller),
                ],
                CorePlayerBlur(widget.controller),
                CorePlayerControls(widget.controller),
              ],
            )
          : CorePlayerBanner(widget.controller),
    );
  }
}
