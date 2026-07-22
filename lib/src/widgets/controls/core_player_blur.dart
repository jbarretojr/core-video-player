import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/core_player_banner.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerBlur extends CorePlayerWidget {
  const CorePlayerBlur(super.controller, {super.key});

  @override
  State<CorePlayerBlur> createState() => _CorePlayerBlurState();
}

class _CorePlayerBlurState extends CorePlayerWidgetState<CorePlayerBlur> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.cast != newState.cast;
  }

  @override
  Widget build(BuildContext context) {
    if (state.cast.isConnect) {
      return Stack(
        alignment: Alignment.center,
        children: [
          CorePlayerBannerImage(widget.controller, true),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
