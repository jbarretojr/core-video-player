// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:core_video_player/src/utils/core_icon_data.dart';

@immutable
class CorePlayerIcons {
  const CorePlayerIcons({
    this.arrow_back = const CoreIconData(Icons.arrow_back, size: 15),
    this.settings = const CoreIconData(Icons.settings, size: 15),
    this.play_arrow = const CoreIconData(Icons.play_arrow, size: 40),
    this.pause = const CoreIconData(Icons.pause, size: 40),
    this.rotate_right = const CoreIconData(Icons.rotate_right, size: 40),
    this.skip_next = const CoreIconData(Icons.skip_next, size: 20),
    this.skip_previous = const CoreIconData(Icons.skip_previous, size: 20),
    this.picture_in_picture = const CoreIconData(Icons.picture_in_picture, size: 18),
    this.fullscreen = const CoreIconData(Icons.fullscreen, size: 25),
    this.fullscreen_exit = const CoreIconData(Icons.fullscreen_exit, size: 25),
    this.forward_10 = const CoreIconData(Icons.forward_10, size: 28),
    this.replay_10 = const CoreIconData(Icons.replay_10, size: 28),
    this.play_circle_outline = const CoreIconData(Icons.play_circle_outline, size: 40),
    this.cast = const CoreIconData(Icons.cast, size: 22),
    this.cast_connected = const CoreIconData(Icons.cast_connected, size: 22, color: Color.fromRGBO(0, 103, 255, 1)),
    this.cast_sharp = const CoreIconData(Icons.cast_sharp, size: 22, color: Colors.blue),
    this.cast_connected_sharp = const CoreIconData(Icons.cast_connected_sharp, size: 22, color: Colors.blue),
  });

  final CoreIconData arrow_back;
  final CoreIconData settings;
  final CoreIconData play_arrow;
  final CoreIconData skip_next;
  final CoreIconData skip_previous;
  final CoreIconData picture_in_picture;
  final CoreIconData pause;
  final CoreIconData fullscreen;
  final CoreIconData fullscreen_exit;
  final CoreIconData forward_10;
  final CoreIconData replay_10;
  final CoreIconData play_circle_outline;
  final CoreIconData cast;
  final CoreIconData cast_connected;
  final CoreIconData rotate_right;
  final CoreIconData cast_sharp;
  final CoreIconData cast_connected_sharp;
}
