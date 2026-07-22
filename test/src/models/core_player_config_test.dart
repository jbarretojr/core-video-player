import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/core_video_player.dart';

void main() {
  test('CorePlayerConfig default values', () {
    const config = CorePlayerConfig();
    expect(config.autoPlay, false);
  });

  test('CorePlayerConfig novos valores', () {
    const autoPlay = true;
    const config = CorePlayerConfig(autoPlay: autoPlay);
    expect(config.autoPlay, autoPlay);
  });

  test('CorePlayerConfig novos valores', () {
    var config = const CorePlayerConfig();
    expect(config.autoPlay, false);

    const autoPlay = true;
    config = config.copyWith(autoPlay: autoPlay);

    expect(config.autoPlay, autoPlay);
  });
}
