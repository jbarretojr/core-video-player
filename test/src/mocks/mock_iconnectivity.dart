import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core_video_player/src/contracts/iconnectivity.dart';

class MockIConnectivity implements IConnectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future(() => [ConnectivityResult.wifi]);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Stream.value([ConnectivityResult.wifi]);
}
