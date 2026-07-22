import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';

void main() {
  test('Instance', () {
    expect(const CorePlayerIcons(), isA<CorePlayerIcons>());
  });

  test('arrow_back', () {
    final icon = const CorePlayerIcons().arrow_back;
    expect(icon, isA<CoreIconData>());
  });

  test('settings', () {
    final icon = const CorePlayerIcons().settings;
    expect(icon, isA<CoreIconData>());
  });

  test('play_arrow', () {
    final icon = const CorePlayerIcons().play_arrow;
    expect(icon, isA<CoreIconData>());
  });

  test('skip_next', () {
    final icon = const CorePlayerIcons().skip_next;
    expect(icon, isA<CoreIconData>());
  });

  test('skip_previous', () {
    final icon = const CorePlayerIcons().skip_previous;
    expect(icon, isA<CoreIconData>());
  });

  test('picture_in_picture', () {
    final icon = const CorePlayerIcons().picture_in_picture;
    expect(icon, isA<CoreIconData>());
  });

  test('pause', () {
    final icon = const CorePlayerIcons().pause;
    expect(icon, isA<CoreIconData>());
  });

  test('fullscreen', () {
    final icon = const CorePlayerIcons().fullscreen;
    expect(icon, isA<CoreIconData>());
  });

  test('fullscreen_exit', () {
    final icon = const CorePlayerIcons().fullscreen_exit;
    expect(icon, isA<CoreIconData>());
  });

  test('forward_10', () {
    final icon = const CorePlayerIcons().forward_10;
    expect(icon, isA<CoreIconData>());
  });

  test('replay_10', () {
    final icon = const CorePlayerIcons().replay_10;
    expect(icon, isA<CoreIconData>());
  });

  test('play_circle_outline', () {
    final icon = const CorePlayerIcons().play_circle_outline;
    expect(icon, isA<CoreIconData>());
  });

  test('cast', () {
    final icon = const CorePlayerIcons().cast;
    expect(icon, isA<CoreIconData>());
  });

  test('cast_connected', () {
    final icon = const CorePlayerIcons().cast_connected;
    expect(icon, isA<CoreIconData>());
  });

  test('rotate_right', () {
    final icon = const CorePlayerIcons().rotate_right;
    expect(icon, isA<CoreIconData>());
  });

  test('cast_sharp', () {
    final icon = const CorePlayerIcons().cast_sharp;
    expect(icon, isA<CoreIconData>());
  });

  test('cast_connected_sharp', () {
    final icon = const CorePlayerIcons().cast_connected_sharp;
    expect(icon, isA<CoreIconData>());
  });
}
