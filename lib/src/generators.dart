import 'dart:math';

import 'package:flutter/material.dart';

List<Color> generateColors(int num) {
  final random = Random();

  return [
    for (int i = 0; i < num; i++) Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255)),
  ];
}
