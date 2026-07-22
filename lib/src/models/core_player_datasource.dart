import 'package:core_video_player/src/models/core_player_resolution.dart';

/// Stores the information for a video.
class CorePlayerDatasource {
  const CorePlayerDatasource({
    required this.title,
    required this.description,
    required this.hasNext,
    required this.hasPrev,
    required this.resolutions,
    this.banner,
    this.assetsError,
    this.subtitle,
    this.subtitleHeaders,
    this.position = Duration.zero,
  });

  /// Title of the video.
  final String title;

  /// Description of the video.
  final String description;

  /// Uri for the video banner.
  final Uri? banner;

  /// Asset path for the video banner, used if loading the main banner fails.
  final String? assetsError;

  /// Indicates whether the video has a next video, used to show the
  /// next-video button.
  final bool hasNext;

  /// Indicates whether the video has a previous video, used to show the
  /// previous-video button.
  final bool hasPrev;

  /// Map of the resolutions available for the video.
  final Map<CorePlayerResolution, Uri> resolutions;

  /// Uri for the video subtitle.
  final Uri? subtitle;

  /// Headers used to download the subtitle.
  final Map<String, String>? subtitleHeaders;

  /// Initial position of the video.
  final Duration position;

  CorePlayerDatasource copyWith({
    String? title,
    String? description,
    Uri? banner,
    String? assetsError,
    bool? hasNext,
    bool? hasPrev,
    Map<CorePlayerResolution, Uri>? resolutions,
    Uri? subtitle,
    Map<String, String>? subtitleHeaders,
    Duration? position,
  }) {
    return CorePlayerDatasource(
      title: title ?? this.title,
      description: description ?? this.description,
      banner: banner ?? this.banner,
      assetsError: assetsError ?? this.assetsError,
      hasNext: hasNext ?? this.hasNext,
      hasPrev: hasPrev ?? this.hasPrev,
      resolutions: resolutions ?? this.resolutions,
      subtitle: subtitle ?? this.subtitle,
      subtitleHeaders: subtitleHeaders ?? this.subtitleHeaders,
      position: position ?? this.position,
    );
  }
}
