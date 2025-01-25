import 'package:flutter/material.dart';

//This is a UI model, it should be mutable
class Ball {
  Animation<Offset> animation;
  AnimationController controller;
  Color color;
  double size;

  Ball(
    this.animation,
    this.controller,
    this.color,
    this.size,
  );
}
