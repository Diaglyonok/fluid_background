import 'dart:math';

import 'package:flutter/material.dart';

class InitialOffsets {
  final List<Offset> offsets;
  factory InitialOffsets.predefined() => const InitialOffsets._(
        [
          Offset(0.3, 0.5),
          Offset(0.1, 0.8),
          Offset(0.5, 0.3),
          Offset(0.0, 0.0),
        ],
      );

  factory InitialOffsets.random(int ballsNum) {
    final random = Random();
    return InitialOffsets._(
      [
        for (int i = 0; i < ballsNum; i++)
          Offset(
            random.nextDouble(),
            random.nextDouble(),
          ),
      ],
    );
  }

  factory InitialOffsets.custom(List<Offset> offsets) {
    return InitialOffsets._(offsets);
  }

  const InitialOffsets._(this.offsets);
}
