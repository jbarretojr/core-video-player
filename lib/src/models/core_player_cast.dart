/// Represents the different chromecast connection states.
enum CorePlayerCast {
  /// Chromecast is not supported or unavailable.
  unavailable,

  /// Chromecast is disconnected.
  disconnect,

  /// Chromecast is connecting.
  connecting,

  /// Chromecast is connected.
  connect;

  /// Returns `true` if chromecast is not supported or unavailable.
  bool get isUnavailable => this == CorePlayerCast.unavailable;

  /// Returns `true` if chromecast is disconnected.
  bool get isDisconnect => this == CorePlayerCast.disconnect;

  /// Returns `true` if chromecast is connecting.
  bool get isConnecting => this == CorePlayerCast.connecting;

  /// Returns `true` if chromecast is connected.
  bool get isConnect => this == CorePlayerCast.connect;
}
