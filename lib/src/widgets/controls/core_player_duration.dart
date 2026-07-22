import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/utils/duration.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerDuration extends CorePlayerWidget {
  const CorePlayerDuration(super.controller, {super.key});

  @override
  State<CorePlayerDuration> createState() => _CorePlayerDurationState();
}

class _CorePlayerDurationState extends CorePlayerWidgetState<CorePlayerDuration> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.position != newState.position ||
        oldState.duration != newState.duration ||
        oldState.isNewPositioning != newState.isNewPositioning;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      sortKey: const OrdinalSortKey(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '${widget.controller.newPosition.format()}/${state.duration.format()}',
          key: const Key('text-duration-player'),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, letterSpacing: -0.2),
          semanticsLabel:
              '''
                          Playback time
                          ${widget.controller.newPosition.format(removeHour: false)}
                          of
                          ${widget.controller.newPosition.format(removeHour: false)}
                        ''',
        ),
      ),
    );
  }
}
