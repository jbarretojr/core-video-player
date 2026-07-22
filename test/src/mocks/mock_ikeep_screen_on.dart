import 'package:core_video_player/src/contracts/ikeep_screen_on.dart';

class MockKeepScreenOn implements IKeepScreenOn {
  @override
  Future<bool> turnOff() async {
    return true;
  }

  @override
  Future<bool> turnOn({bool on = true, bool withAllowLockWhileScreenOn = false}) async {
    return true;
  }
}
