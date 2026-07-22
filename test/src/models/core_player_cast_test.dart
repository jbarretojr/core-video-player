import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/src/models/core_player_cast.dart';

void main() {
  test('CorePlayerCast values', () {
    expect(CorePlayerCast.values.length, equals(4));
  });

  test('CorePlayerCast.unavailable', () {
    expect(CorePlayerCast.values.contains(CorePlayerCast.unavailable), true);
  });

  test('CorePlayerCast.disconnect', () {
    expect(CorePlayerCast.values.contains(CorePlayerCast.disconnect), true);
  });

  test('CorePlayerCast.connecting', () {
    expect(CorePlayerCast.values.contains(CorePlayerCast.connecting), true);
  });

  test('CorePlayerCast.connect', () {
    expect(CorePlayerCast.values.contains(CorePlayerCast.connect), true);
  });
}
