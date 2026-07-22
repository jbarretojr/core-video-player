import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerNext extends CorePlayerStatelessWidget {
  const CorePlayerNext(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final exist = controller.datasource?.hasNext == true;
    final icons = controller.icons;

    return ExcludeSemantics(
      excluding: !exist,
      child: Semantics(
        label: 'Next video',
        sortKey: const OrdinalSortKey(9),
        button: true,
        excludeSemantics: true,
        child: IconButton(
          key: const Key('tap-next-video-player'),
          onPressed: exist ? controller.next : () {},
          icon: Icon(icons.skip_next.icon),
          color: exist ? icons.skip_next.color : Colors.transparent,
          iconSize: icons.skip_next.size,
        ),
      ),
    );
  }
}
