import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerPip extends CorePlayerWidget {
  const CorePlayerPip(super.controller, {super.key});

  @override
  State<CorePlayerPip> createState() => _CorePlayerPipState();
}

class _CorePlayerPipState extends CorePlayerWidgetState<CorePlayerPip> {
  late final CoreIconData _icon;

  @override
  void initState() {
    super.initState();
    _icon = widget.controller.icons.picture_in_picture;
  }

  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.isPipSupported != newState.isPipSupported;
  }

  @override
  Widget build(BuildContext context) {
    if (!state.isPipSupported) return const SizedBox.shrink();

    return Semantics(
      label: 'Minimize video',
      hint: 'Tap to start floating mode',
      excludeSemantics: true,
      button: true,
      sortKey: const OrdinalSortKey(11),
      child: ColoredBox(
        color: Colors.transparent,
        child: IconButton(
          key: const Key('tap-pip-player'),
          onPressed: () => widget.controller.startPip(context),
          icon: Icon(_icon.icon),
          color: _icon.color,
          iconSize: _icon.size,
        ),
      ),
    );
  }
}
