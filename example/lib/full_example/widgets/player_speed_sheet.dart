import 'package:flutter/material.dart';
import 'package:core_video_player/core_video_player.dart';

/// Bottom sheet opened from the player's speed button, with a slider plus
/// quick presets bounded by the platform's min/max supported speed.
class PlayerSpeedSheet extends StatefulWidget {
  const PlayerSpeedSheet({required this.controller, required this.config, super.key});

  final CorePlayerController controller;
  final CorePlayerControlsConfig config;

  @override
  State<PlayerSpeedSheet> createState() => _PlayerSpeedSheetState();
}

class _PlayerSpeedSheetState extends State<PlayerSpeedSheet> {
  static const _presets = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  late double _speed = widget.config.state.speed;

  @override
  Widget build(BuildContext context) {
    final presets = _presets.where((preset) => preset >= widget.config.minSpeed && preset <= widget.config.maxSpeed);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Speed: ${_speed.toStringAsFixed(2)}x'),
            Slider(
              value: _speed,
              min: widget.config.minSpeed,
              max: widget.config.maxSpeed,
              onChanged: (value) {
                setState(() => _speed = value);
                widget.controller.setSpeed(value);
              },
            ),
            Wrap(
              spacing: 8,
              children: [
                for (final preset in presets)
                  ChoiceChip(
                    label: Text('${preset}x'),
                    selected: _speed == preset,
                    onSelected: (_) {
                      setState(() => _speed = preset);
                      widget.controller.setSpeed(preset);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
