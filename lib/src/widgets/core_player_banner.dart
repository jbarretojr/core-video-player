import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/controls/core_player_close.dart';
import 'package:core_video_player/src/widgets/controls/core_player_next.dart';
import 'package:core_video_player/src/widgets/controls/core_player_prev.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerBanner extends CorePlayerWidget {
  const CorePlayerBanner(super.controller, {super.key});

  @override
  State<CorePlayerBanner> createState() => _CorePlayerBannerState();
}

class _CorePlayerBannerState extends CorePlayerWidgetState<CorePlayerBanner> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.controlsMode != newState.controlsMode;
  }

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.shortestSide > 600;

  @override
  Widget build(BuildContext context) {
    if (widget.controller.value.controlsMode.isAlwaysHidden) {
      return Center(child: CorePlayerBannerImage(widget.controller, true));
    }

    return CorePlayerBannerImage(widget.controller, false);
  }
}

class CorePlayerBannerImage extends CorePlayerStatelessWidget {
  const CorePlayerBannerImage(super.controller, this.bannerOnly, {super.key});
  final bool bannerOnly;

  @override
  Widget build(BuildContext context) {
    Image image;
    final banner = controller.datasource?.banner;
    final assetsError = controller.datasource?.assetsError;

    if (banner != null && banner.isScheme('file')) {
      image = Image.file(
        File.fromUri(banner),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            assetsError != null ? Image(image: AssetImage(assetsError), fit: BoxFit.cover) : const SizedBox(),
      );

      return _stackBanner(image, bannerOnly);
    }

    image = Image.network(
      banner.toString(),
      fit: BoxFit.cover,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return const ColoredBox(
            color: Colors.black,
            child: Center(
              child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(color: Colors.white)),
            ),
          );
        }

        return image;
      },
      errorBuilder: (context, error, stackTrace) =>
          assetsError != null ? Image(image: AssetImage(assetsError), fit: BoxFit.cover) : const SizedBox(),
    );

    return _stackBanner(image, bannerOnly);
  }

  Widget _stackBanner(Widget image, bool bannerOnly) {
    return Stack(
      alignment: Alignment.center,
      children: [
        image,
        if (!bannerOnly)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CorePlayerPrev(controller),
                  Semantics(
                    label: 'Play video',
                    hint: 'Double tap to play the video',
                    sortKey: const OrdinalSortKey(1),
                    excludeSemantics: true,
                    button: true,
                    child: InkWell(
                      key: const Key('tap-play-video'),
                      onTap: controller.play,
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.transparent,
                        child: Icon(
                          controller.icons.play_circle_outline.icon,
                          size: controller.icons.play_circle_outline.size,
                          color: controller.icons.play_circle_outline.color,
                          shadows: const [Shadow(blurRadius: 10)],
                        ),
                      ),
                    ),
                  ),
                  CorePlayerNext(controller),
                ],
              ),
            ),
          ),
        if (controller.showTitle && !bannerOnly)
          Align(alignment: Alignment.topRight, child: CorePlayerClose(controller)),
      ],
    );
  }
}
