import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/src/models/core_player_state.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerSpeed extends CorePlayerWidget {
  const CorePlayerSpeed(super.controller, {super.key});

  @override
  State<CorePlayerSpeed> createState() => _CorePlayerSpeedState();
}

class _CorePlayerSpeedState extends CorePlayerWidgetState<CorePlayerSpeed> {
  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.speed != newState.speed;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Playback speed',
      hint: 'Tap to change the playback speed',
      sortKey: const OrdinalSortKey(3),
      value: state.speed.toStringAsFixed(2),
      button: true,
      excludeSemantics: true,
      child: TextButton(
        key: const Key('tap-speed-player'),
        onPressed: () => widget.controller.onTapSpeed?.call(widget.controller.controlsConfig),
        style: TextButton.styleFrom(minimumSize: Size.zero),
        child: Text(
          '${state.speed.toStringAsFixed(2)}x',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
