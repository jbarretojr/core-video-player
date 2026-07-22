import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:core_video_player/core_video_player.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';
import 'package:core_video_player/src/widgets/core_player_widget.dart';

class CorePlayerChromecast extends CorePlayerWidget {
  const CorePlayerChromecast(super.controller, {super.key});

  @override
  State<CorePlayerChromecast> createState() => _CorePlayerChromecastState();
}

class _CorePlayerChromecastState extends CorePlayerWidgetState<CorePlayerChromecast> {
  late final Timer _timer;
  bool _changeIcon = false;
  late final CorePlayerIcons _icons;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _changeIcon = !_changeIcon);
    });
    _icons = widget.controller.icons;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  bool shouldUpdate(CorePlayerState oldState, CorePlayerState newState) {
    return oldState.cast != newState.cast;
  }

  @override
  Widget build(BuildContext context) {
    if (state.cast == CorePlayerCast.unavailable) {
      return const SizedBox();
    }

    final child = state.cast == CorePlayerCast.disconnect
        ? buildDisconnectWidget()
        : state.cast == CorePlayerCast.connecting
        ? buildConnectingWidget()
        : buildConnectWidget();

    return Semantics(
      label: 'Cast video',
      hint: 'Tap to start chromecast',
      excludeSemantics: true,
      button: true,
      sortKey: const OrdinalSortKey(12),
      child: ColoredBox(color: Colors.transparent, child: child),
    );
  }

  Widget buildDisconnectWidget() {
    final icon = _icons.cast;
    return IconButton(
      key: const Key('tap-cast-player'),
      onPressed: widget.controller.onEnterChromecast,
      icon: Icon(icon.icon),
      color: icon.color,
      iconSize: icon.size,
    );
  }

  Widget buildConnectingWidget() {
    return IconButton(
      key: const Key('tap-cast-player'),
      onPressed: widget.controller.onExitChromecast,
      icon: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Icon(
          _changeIcon ? _icons.cast_sharp.icon : _icons.cast_connected_sharp.icon,
          size: _changeIcon ? _icons.cast_sharp.size : _icons.cast_connected_sharp.size,
          key: ValueKey<bool>(_changeIcon),
          color: _changeIcon ? _icons.cast_sharp.color : _icons.cast_connected_sharp.color,
        ),
      ),
    );
  }

  Widget buildConnectWidget() {
    final icon = _icons.cast_connected;
    return IconButton(
      key: const Key('tap-cast-player'),
      onPressed: widget.controller.onExitChromecast,
      icon: Icon(icon.icon),
      color: icon.color,
      iconSize: icon.size,
    );
  }
}
