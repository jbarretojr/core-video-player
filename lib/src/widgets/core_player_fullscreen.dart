import 'package:flutter/material.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/controls/core_player_blur.dart';
import 'package:core_video_player/src/widgets/controls/core_player_controls.dart';
import 'package:core_video_player/src/widgets/core_player_banner.dart';
import 'package:core_video_player/src/widgets/core_player_subtitles.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';
import 'package:video_player/video_player.dart';

class CorePlayerFullscreen extends CorePlayerWidget {
  const CorePlayerFullscreen(super.controller, {super.key});

  @override
  State<CorePlayerFullscreen> createState() => _CorePlayerFullscreenState();
}

class _CorePlayerFullscreenState extends CorePlayerWidgetState<CorePlayerFullscreen> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.showControls != newState.showControls ||
        oldState.isLoading != newState.isLoading ||
        oldState.isInitialized != newState.isInitialized ||
        oldState.resolution != newState.resolution ||
        oldState.cast != newState.cast;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, _) async {
        widget.controller
          ..tapFullScreen()
          ..toggleFullScreen(context, popScope: false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: state.isInitialized || state.isLoading
            ? Stack(
                alignment: Alignment.center,
                children: [
                  if (!state.isLoading && !state.cast.isConnect) ...[
                    Builder(
                      builder: (context) {
                        final controller = widget.controller.videoController.controller;
                        if (controller is VideoPlayerController) {
                          return AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller));
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
      ),
    );
  }
}
