/// Enum representing the different display modes for the player controls.
enum CorePlayerControlsMode {
  /// Automatic mode.
  ///
  /// The controls are shown when the user taps the screen and hidden after
  /// 4 seconds of inactivity.
  auto,

  /// Always visible mode.
  alwaysVisible,

  /// Always hidden mode.
  alwaysHidden;

  /// Returns `true` if the current mode is automatic.
  bool get isAuto => this == CorePlayerControlsMode.auto;

  /// Returns `true` if the current mode is always visible.
  bool get isAlwaysVisible => this == CorePlayerControlsMode.alwaysVisible;

  /// Returns `true` if the current mode is always hidden.
  bool get isAlwaysHidden => this == CorePlayerControlsMode.alwaysHidden;
}
