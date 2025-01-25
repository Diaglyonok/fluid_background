import 'package:fluid_background/src/generators.dart';
import 'package:flutter/material.dart';

class InitialColors {
  final List<Color> colors;
  final bool isRandom;

  factory InitialColors.predefined() => const InitialColors._(
        [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.amber,
        ],
      );

  factory InitialColors.random(int ballsNum) {
    return InitialColors._(generateColors(ballsNum), isRandom: true);
  }

  factory InitialColors.custom(List<Color> colors) {
    return InitialColors._(colors);
  }

  const InitialColors._(this.colors, {this.isRandom = false});
}
