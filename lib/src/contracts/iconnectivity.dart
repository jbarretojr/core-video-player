import 'package:connectivity_plus/connectivity_plus.dart';

abstract class IConnectivity {
  Stream<List<ConnectivityResult>> get onConnectivityChanged;

  Future<List<ConnectivityResult>> checkConnectivity();
}

class ConnectivityPlayer implements IConnectivity {
  const ConnectivityPlayer();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Connectivity().checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Connectivity().onConnectivityChanged;
}
