import 'package:flutter/material.dart';
import 'package:core_video_player/src/core_player_controller.dart';
import 'package:core_video_player/src/models/core_player_state.dart';

/// Base class for the player's Stateless widgets so they can access the
/// [CorePlayerController].
abstract class CorePlayerStatelessWidget extends StatelessWidget {
  const CorePlayerStatelessWidget(this.controller, {super.key});
  final CorePlayerController controller;
}

/// Base class for the player's Stateful widgets so they can access the
/// [CorePlayerController] and update the widget state whenever the player
/// state changes.
abstract class CorePlayerWidget extends StatefulWidget {
  const CorePlayerWidget(this.controller, {super.key});
  final CorePlayerController controller;
}

abstract class CorePlayerWidgetState<T extends CorePlayerWidget> extends State<T> {
  late CorePlayerState state;

  @override
  void initState() {
    state = widget.controller.value;
    widget.controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (!shouldUpdate(state, widget.controller.value)) return;

    setState(() {
      state = widget.controller.value;
    });
  }

  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState);
}
