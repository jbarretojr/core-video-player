import 'package:core_video_player/src/core_player_controller.dart';
import 'package:core_video_player/src/models/core_player_icons.dart';

/// Stores the player's static configuration.
///
/// The configuration is passed to [CorePlayerController] through its
/// constructor.
class CorePlayerConfig {
  const CorePlayerConfig({
    this.autoPlay = false,
    this.forceCloseInAutoPlay = false,
    this.icons = const CorePlayerIcons(),
  });

  /// Enables automatic video playback.
  ///
  /// This setting can be changed while the video is playing through
  /// [CorePlayerController.setAutoPlay].
  final bool autoPlay;

  /// Disables player playback when autoPlay is enabled and the video is
  /// still in the middle of initialization.
  final bool forceCloseInAutoPlay;

  /// Stores the icons used by the library.
  ///
  /// Allows the default icons to be customized through the [CorePlayerConfig]
  /// provided to the [CorePlayerController] instance. Example:
  /// ```dart
  /// final _playerController = CorePlayerController(
  ///   config: CorePlayerConfig(
  ///     icons: CorePlayerIcons(
  ///       arrow_back: CoreIconData([IconData], size: [double], color: [Color])
  ///     )
  ///   )
  /// );
  /// ```
  final CorePlayerIcons icons;

  CorePlayerConfig copyWith({bool? autoPlay, bool? forceCloseInAutoPlay, CorePlayerIcons? icons}) {
    return CorePlayerConfig(
      autoPlay: autoPlay ?? this.autoPlay,
      forceCloseInAutoPlay: forceCloseInAutoPlay ?? this.forceCloseInAutoPlay,
      icons: icons ?? this.icons,
    );
  }
}
