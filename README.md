# core_video_player

A customizable video player widget for Flutter.

Built on top of [video_player](https://pub.dev/packages/video_player), `core_video_player` provides a ready-made layout and controls, plus extra functionality such as fullscreen, picture-in-picture, subtitles, Chromecast hooks, and automatic reconnection handling.

## Features

- Playback controls (play/pause, seek, forward/rewind 10s, speed, resolution switching)
- Fullscreen mode
- Picture-in-picture (Android only)
- Subtitles (SRT and WebVTT)
- Keeps the screen on during playback
- Automatic connectivity checks and reconnection
- Chromecast UI hooks (click and layout events only — connection and playback are handled through your own Cast integration)
- Fully customizable icon set

## Getting started

Add `core_video_player` to your `pubspec.yaml`:

```yaml
dependencies:
  core_video_player:
    git:
      url: <your-repository-url>
      ref: master
```

Then install the dependency:

```sh
flutter pub get
```

## Usage

```dart
import 'package:core_video_player/core_video_player.dart';

// Create a controller.
final playerController = CorePlayerController.init();

// (Optional) Register callbacks for player events.
playerController.events = CorePlayerEvents(
  onInitialized: (datasource) {},
  onPlay: (state) {},
);

// Set the video to be played.
playerController.changeDatasource(
  CorePlayerDatasource(
    title: 'My video',
    description: 'Video description',
    hasNext: false,
    hasPrev: false,
    resolutions: {
      CorePlayerResolution.p480: Uri.parse('https://example.com/video.mp4'),
    },
  ),
);

// Render the player.
CorePlayer(playerController)
```

### Customizing icons

The default icons can be overridden through `CorePlayerConfig`:

```dart
final playerController = CorePlayerController.init(
  config: CorePlayerConfig(
    icons: CorePlayerIcons(
      arrow_back: CoreIconData(Icons.arrow_back_ios, size: 20, color: Colors.white),
    ),
  ),
);
```

## Project structure

```sh
lib/
|- src/
|  |- contracts/  # Abstractions over connectivity, keep-screen-on and video_player
|  |- models/     # Data models and enums
|  |- utils/      # Utility functions and custom icon access
|  |- widgets/
|  |  |- controls/                   # Player control widgets
|  |  |- core_player_banner.dart      # Banner shown before the video is initialized
|  |  |- core_player_fullscreen.dart  # Fullscreen screen
|  |  |- core_player_subtitles.dart   # Subtitle widget
|  |  |- core_player_widget.dart      # Base classes for the player widgets
|  |- core_player_controller.dart     # Player controller
|  |- core_player.dart                # Main widget
|- core_video_player.dart              # Exports the controller, widget and models
```

## Roadmap

- [x] Playback controls
- [x] Fullscreen (does not control device rotation)
- [x] Picture-in-picture (Android only)
- [x] Subtitles
- [x] Keep screen on during playback
- [x] Connectivity check and automatic reconnection
- [x] Chromecast (click and layout events only — connection and playback must be handled through your own integration)
- [ ] Background playback (opt-in configuration)
- [ ] Device rotation control (opt-in configuration)
- [ ] Status bar controls (opt-in configuration)

## Running the example

```sh
cd example
flutter run
```

## Testing

For first-time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate coverage report
genhtml coverage/lcov.info -o coverage/

# Open coverage report
open coverage/index.html
```

[very_good_cli_link]: https://pub.dev/packages/very_good_cli
