import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerConfig extends CorePlayerStatelessWidget {
  const CorePlayerConfig(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final icon = controller.icons.settings;

    return Semantics(
      label: 'Settings',
      sortKey: const OrdinalSortKey(4),
      button: true,
      excludeSemantics: true,
      child: IconButton(
        key: const Key('tap-settings-player'),
        icon: Icon(icon.icon, color: icon.color),
        onPressed: () => controller.onTapConfig?.call(controller.controlsConfig),
        iconSize: icon.size,
      ),
    );
  }
}
