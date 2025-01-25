import 'package:flutter/material.dart';

//This is a UI model, it should be mutable
class Bubble {
  Animation<Offset> animation;
  AnimationController controller;
  Color color;
  double size;

  Bubble(
    this.animation,
    this.controller,
    this.color,
    this.size,
  );
}
