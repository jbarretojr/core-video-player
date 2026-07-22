import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerPrev extends CorePlayerStatelessWidget {
  const CorePlayerPrev(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final exist = controller.datasource?.hasPrev == true;
    final icon = controller.icons.skip_previous;

    return ExcludeSemantics(
      excluding: !exist,
      child: Semantics(
        label: 'Previous video',
        sortKey: const OrdinalSortKey(5),
        button: true,
        excludeSemantics: true,
        child: IconButton(
          key: const Key('tap-prev-video-player'),
          onPressed: exist ? controller.prev : () {},
          icon: Icon(icon.icon),
          color: exist ? icon.color : Colors.transparent,
          iconSize: icon.size,
        ),
      ),
    );
  }
}
