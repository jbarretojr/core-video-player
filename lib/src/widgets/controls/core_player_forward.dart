import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerForward extends CorePlayerStatelessWidget {
  const CorePlayerForward(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final icon = controller.icons.forward_10;

    return Semantics(
      label: 'Forward 10 seconds',
      sortKey: const OrdinalSortKey(8),
      button: true,
      excludeSemantics: true,
      child: IconButton(
        key: const Key('tap-forward-time-player'),
        onPressed: controller.forward10,
        icon: Icon(icon.icon),
        color: icon.color,
        iconSize: icon.size,
      ),
    );
  }
}
