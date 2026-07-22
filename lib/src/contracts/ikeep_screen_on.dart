import 'package:keep_screen_on/keep_screen_on.dart';

abstract class IKeepScreenOn {
  Future<bool> turnOn({bool on = true, bool withAllowLockWhileScreenOn = false});

  Future<bool> turnOff();
}

class KeepScreenOnPlayer implements IKeepScreenOn {
  const KeepScreenOnPlayer();

  @override
  Future<bool> turnOff() async {
    return KeepScreenOn.turnOff();
  }

  @override
  Future<bool> turnOn({bool on = true, bool withAllowLockWhileScreenOn = false}) async {
    return KeepScreenOn.turnOn(on: on, withAllowLockWhileScreenOn: withAllowLockWhileScreenOn);
  }
}
