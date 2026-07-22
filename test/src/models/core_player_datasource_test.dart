import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';

void main() {
  test('CorePlayerDatasource', () {
    final dataSource = CorePlayerDatasource(
      title: 'title',
      description: 'description',
      hasNext: false,
      hasPrev: false,
      resolutions: {
        CorePlayerResolution.p480: Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      },
    );

    expect(dataSource, isA<CorePlayerDatasource>());
    expect(dataSource.resolutions, isA<Map<CorePlayerResolution, Uri>>());
    expect(dataSource.resolutions.length, equals(1));
  });
}
