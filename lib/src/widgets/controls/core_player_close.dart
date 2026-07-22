import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerClose extends CorePlayerStatelessWidget {
  const CorePlayerClose(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final icons = controller.icons;

    return InkWell(
      key: const Key('tap-close-player'),
      onTap: () async {
        if (controller.value.isFullscreen) {
          controller
            ..tapFullScreen()
            ..toggleFullScreen(context, forceTo: false);
          return;
        }

        controller.close();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Semantics(
          label: 'Back',
          hint: 'Tap to go back to the previous screen',
          excludeSemantics: true,
          sortKey: const OrdinalSortKey(2),
          button: true,
          child: Row(
            children: [
              Icon(
                icons.arrow_back.icon,
                size: icons.arrow_back.size,
                color: icons.arrow_back.color,
                shadows: const [Shadow(blurRadius: 10)],
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  key: const Key('title-video-player'),
                  controller.datasource?.title ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white, shadows: [const Shadow(blurRadius: 10)]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
