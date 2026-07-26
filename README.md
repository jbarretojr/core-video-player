<h2 align="center">Core Video Player</h2>

<p align="center"> A customizable video player widget for Flutter. Built on top of <a href="https://pub.dev/packages/video_player">video_player</a>, <code>core_video_player</code> provides a ready-made layout and controls, plus extra functionality such as fullscreen, picture-in-picture, subtitles, Chromecast hooks, and automatic reconnection handling. </p>

<p align="center">
<a href="https://pub.dev/packages/core_video_player"><img src="https://img.shields.io/pub/v/core_video_player.svg" alt="pub"></a>
<a href="https://github.com/jbarretojr/core-video-player"><img src="https://img.shields.io/github/stars/jbarretojr/core-video-player?color=deeppink" alt="Stars"></a>
</p>

---

|             | Android | iOS   | macOS  | Web   |
|-------------|---------|-------|--------|-------|
| **Support** | SDK 24+ | 13.0+ | 10.15+ | Any\* |

![The example app running in iOS](https://github.com/jbarretojr/core-video-player/doc/demo_iphone.gif?raw=true)

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

or 

flutter pub add core_video_player

```yaml
dependencies:
  core_video_player: ^1.1.0
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

## Roadmap

- [x] Playback controls
- [x] Fullscreen (does not control device rotation)
- [x] Picture-in-picture (Android only)
- [x] Subtitles
- [x] Keep screen on during playback
- [x] Connectivity check and automatic reconnection
- [x] Chromecast (click and layout events only — connection and playback must be handled through your own integration)
- [-] Background playback (opt-in configuration)
- [-] Device rotation control (opt-in configuration)
- [-] Status bar controls (opt-in configuration)

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

[very_good_cli_link]: https://pub.dev/packages/very_good_cli
