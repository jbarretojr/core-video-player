import 'package:flutter/material.dart';
import 'package:core_video_player/core_video_player.dart';

/// Bottom sheet opened from the player's settings (gear) button, showing
/// autoplay, quality and the example's own auto-rotate preference.
class PlayerSettingsSheet extends StatefulWidget {
  const PlayerSettingsSheet({
    required this.controller,
    required this.config,
    required this.autoRotateEnabled,
    required this.onChangeAutoRotate,
    super.key,
  });

  final CorePlayerController controller;
  final CorePlayerControlsConfig config;
  final bool autoRotateEnabled;
  final ValueChanged<bool> onChangeAutoRotate;

  @override
  State<PlayerSettingsSheet> createState() => _PlayerSettingsSheetState();
}

class _PlayerSettingsSheetState extends State<PlayerSettingsSheet> {
  late bool _autoRotateEnabled = widget.autoRotateEnabled;

  @override
  Widget build(BuildContext context) {
    final resolutions = widget.config.resolutions;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Autoplay'),
            subtitle: const Text('Advance to the next lesson when finished'),
            value: widget.controller.config.autoPlay,
            onChanged: (value) {
              widget.controller.setAutoPlay(autoPlay: value);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Auto rotation'),
            subtitle: const Text('Enter fullscreen when the device rotates'),
            value: _autoRotateEnabled,
            onChanged: (value) {
              setState(() => _autoRotateEnabled = value);
              widget.onChangeAutoRotate(value);
            },
          ),
          if (resolutions.length > 1) ...[
            const Divider(height: 1),
            RadioGroup<CorePlayerResolution>(
              groupValue: widget.config.state.resolution,
              onChanged: (value) {
                if (value != null) widget.controller.setResolution(value);
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  for (final resolution in resolutions)
                    RadioListTile<CorePlayerResolution>(title: Text(resolution.toString()), value: resolution,),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
