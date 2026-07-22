/// Helpers for the Duration class.
extension DurationExtension on Duration {
  /// Formats the duration as HH:mm:ss.
  ///
  /// If [removeHour] is `true` and the duration is less than an hour, the
  /// hour value is removed.
  String format({bool removeHour = true}) {
    final strTime = toString().split('.').first.padLeft(8, '0');

    final timeSplited = strTime.split(':');

    if (timeSplited[0] == '00' && removeHour) {
      timeSplited.removeAt(0);
    }

    return timeSplited.join(':');
  }

  /// Returns the duration clamped between [lowerLimit] and [upperLimit].
  Duration clamp(Duration lowerLimit, Duration upperLimit) {
    if (this < lowerLimit) return lowerLimit;
    if (this > upperLimit) return upperLimit;
    return this;
  }

  /// Returns the duration ignoring milliseconds and microseconds.
  Duration round() {
    return Duration(seconds: inSeconds);
  }
}

Future<void> delay(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds), () {});
}
