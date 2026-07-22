import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerRewind extends CorePlayerStatelessWidget {
  const CorePlayerRewind(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final icon = controller.icons.replay_10;

    return Semantics(
      label: 'Rewind 10 seconds',
      sortKey: const OrdinalSortKey(6),
      button: true,
      excludeSemantics: true,
      child: IconButton(
        key: const Key('tap-rewind-time-player'),
        onPressed: controller.rewind10,
        icon: Icon(icon.icon),
        color: icon.color,
        iconSize: icon.size,
      ),
    );
  }
}
