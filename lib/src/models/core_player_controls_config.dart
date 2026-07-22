import 'package:core_video_player/src/models/core_player_resolution.dart';
import 'package:core_video_player/src/models/core_player_state.dart';

/// Standardizes the callback used for the player's configuration button.
///
/// Since the library doesn't provide a configuration widget, this callback
/// is used to pass all the information needed to display it in the app.
typedef CorePlayerControlsConfigFunction = void Function(CorePlayerControlsConfig);

/// Stores the player's configuration options.
class CorePlayerControlsConfig {
  const CorePlayerControlsConfig({
    required this.state,
    required this.resolutions,
    required this.maxSpeed,
    required this.minSpeed,
  });

  /// Current state of the player.
  final CorePlayerState state;

  /// List of resolutions available for the current video.
  final List<CorePlayerResolution> resolutions;

  /// Maximum playback speed for the video.
  final double maxSpeed;

  /// Minimum playback speed for the video.
  final double minSpeed;
}
