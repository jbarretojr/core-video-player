import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerFullscreen extends CorePlayerWidget {
  const CorePlayerFullscreen(super.controller, {super.key});

  @override
  State<CorePlayerFullscreen> createState() => _CorePlayerFullscreenState();
}

class _CorePlayerFullscreenState extends CorePlayerWidgetState<CorePlayerFullscreen> {
  late final CorePlayerIcons _icons;

  @override
  void initState() {
    super.initState();
    _icons = widget.controller.icons;
  }

  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.isFullscreen != newState.isFullscreen;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: state.isFullscreen ? 'Exit fullscreen' : 'Enter fullscreen',
      hint: 'Tap to ${state.isFullscreen ? 'exit fullscreen' : 'enter fullscreen'}',
      excludeSemantics: true,
      button: true,
      sortKey: const OrdinalSortKey(13),
      child: ColoredBox(
        color: Colors.transparent,
        child: IconButton(
          key: const Key('tap-fullscreen-player'),
          onPressed: () {
            widget.controller
              ..tapFullScreen()
              ..toggleFullScreen(context);
          },
          icon: Icon(state.isFullscreen ? _icons.fullscreen_exit.icon : _icons.fullscreen.icon),
          color: state.isFullscreen ? _icons.fullscreen_exit.color : _icons.fullscreen.color,
          iconSize: state.isFullscreen ? _icons.fullscreen_exit.size : _icons.fullscreen.size,
        ),
      ),
    );
  }
}
