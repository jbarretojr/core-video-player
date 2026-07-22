import 'package:flutter/material.dart';
import 'package:core_video_player/core_video_player.dart';

import '../lesson.dart';

/// Small persistent bar shown when the full player is collapsed, similar to
/// a music-player miniplayer. Tapping it re-expands the full player.
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({
    required this.controller,
    required this.lesson,
    required this.onTap,
    required this.onClose,
    super.key,
  });

  final CorePlayerController controller;
  final Lesson lesson;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CorePlayerState>(
      valueListenable: controller,
      builder: (context, state, _) {
        final progress =
            state.duration.inMilliseconds == 0 ? 0.0 : state.position.inMilliseconds / state.duration.inMilliseconds;

        return Material(
          elevation: 8,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: InkWell(
            onTap: onTap,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lesson.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                lesson.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: state.isPlaying ? controller.pause : controller.play,
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(value: progress, minHeight: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
