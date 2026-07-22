import 'package:core_video_player/core_video_player.dart';

/// A mock playlist item used by the full example to simulate a course
/// with several video lessons.
class Lesson {
  const Lesson({required this.title, required this.description, required this.banner, required this.resolutions});

  final String title;
  final String description;
  final Uri banner;
  final Map<CorePlayerResolution, Uri> resolutions;
}

final banner = Uri.parse(
  'https://blog.codemagic.io/uploads/covers/codemagic-blog-youtube-flutter-from-scratch-flutter-project-structure-and-widgets-3-thumbnail.png',
);

/// Sample lessons pointing to public domain / demo videos, reused across
/// resolutions just to illustrate the quality-switch feature.
final List<Lesson> sampleLessons = [
  Lesson(
    title: '1. Introduction to Flutter',
    description: 'An overview of basic widgets and hot reload.',
    banner: banner,
    resolutions: {
      CorePlayerResolution.p480: Uri.parse(
        'https://dn801203.us.archive.org/0/items/BigBuckBunny_328/BigBuckBunny_512kb.mp4',
      ),
    },
  ),
  Lesson(
    title: '2. Organizing the layout',
    description: 'How to structure a screen widget tree.',
    banner: banner,
    resolutions: {CorePlayerResolution.p720: Uri.parse('https://www.papytane.com/mp4/bonjour.mp4')},
  ),
  Lesson(
    title: '3. Navigation and state',
    description: 'Navigation between screens and simple state management.',
    banner: banner,
    resolutions: {CorePlayerResolution.p1080: Uri.parse('https://www.papytane.com/mp4/paysborn.mp4')},
  ),
];
