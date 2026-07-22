import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/src/utils/duration.dart';

void main() {
  test('FormatDuration without hour', () async {
    final formattedTime = const Duration(minutes: 10, seconds: 4).format();
    expect(formattedTime, '10:04');

    expect(formattedTime, '10:04');
  });

  test('FormatDuration with hour', () async {
    final formattedTime = const Duration(hours: 1, minutes: 10, seconds: 4).format();

    expect(formattedTime, '01:10:04');
  });

  test('FormatDuration with zero hour', () async {
    final formattedTime = const Duration(minutes: 10, seconds: 4).format(removeHour: false);

    expect(formattedTime, '00:10:04');
  });

  test('DurationExtension position > upperLimit', () async {
    const upperLimit = Duration(minutes: 10, seconds: 3);
    final newPosition = const Duration(minutes: 10, seconds: 4).clamp(Duration.zero, upperLimit);

    expect(newPosition, upperLimit);
  });

  test('DurationExtension position < lowerLimit', () async {
    const lowerLimit = Duration(minutes: 10, seconds: 5);
    final newPosition = const Duration(
      minutes: 10,
      seconds: 4,
    ).clamp(lowerLimit, const Duration(hours: 1, minutes: 10, seconds: 10));

    expect(newPosition, lowerLimit);
  });

  test('DurationExtension position = lowerLimit', () async {
    const duration = Duration(minutes: 10, seconds: 4);
    final newPosition = duration.clamp(duration, duration);

    expect(newPosition, duration);
  });

  test('DurationExtension position = lowerLimit', () async {
    const duration = Duration(minutes: 10, seconds: 4);
    final newPosition = duration.round();

    expect(newPosition, duration);
  });
}
