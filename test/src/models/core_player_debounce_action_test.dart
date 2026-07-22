import 'package:flutter_test/flutter_test.dart';
import 'package:core_video_player/src/models/core_player_debounce_action.dart';

void main() {
  test('DebounceAction values', () {
    expect(DebounceAction.values.length, equals(6));
  });

  test('DebounceAction.seek', () {
    expect(DebounceAction.values.contains(DebounceAction.seek), true);
  });

  test('DebounceAction.speed', () {
    expect(DebounceAction.values.contains(DebounceAction.speed), true);
  });

  test('DebounceAction.resolution', () {
    expect(DebounceAction.values.contains(DebounceAction.resolution), true);
  });

  test('DebounceAction.autoPlay', () {
    expect(DebounceAction.values.contains(DebounceAction.autoPlay), true);
  });

  test('DebounceAction.pip', () {
    expect(DebounceAction.values.contains(DebounceAction.pip), true);
  });
}
