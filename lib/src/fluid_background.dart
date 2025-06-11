import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'generators.dart';
import 'models/bubble.dart';
import 'models/initial_colors.dart';
import 'models/initial_offsets.dart';

part 'fluid_background_controller.dart';

class FluidBackground extends StatefulWidget {
  /// Initial Positions (Offsets) of every bubble:
  /// 1. Could be [InitialOffsets.custom]
  ///    So you could set your own positions list
  ///
  /// 2. Could be [InitialOffsets.predefined]
  ///    So there will be just a set of 4 pre-defined positions
  ///
  /// 3. Could be [InitialOffsets.random]
  ///    So positions list will be generated in a random way
  ///
  /// Important: All positions (dx, dy) are modified with sin() functions.
  ///            So it's not aligned with Offset(x, y) on the screen
  /// Important: [initialPositions] length should be same as [initialColors] length.
  final InitialOffsets initialPositions;

  /// Initial colors:
  /// 1. Could be [InitialColors.custom]
  ///    So you could set your own colors list
  ///
  /// 2. Could be [InitialColors.predefined]
  ///    So there will be just a set of 4 pre-defined colors
  ///
  /// 3. Could be [InitialColors.random]
  ///    So colors list will be generated in a random way
  ///
  /// Important: [initialColors] length should be same as [initialPositions] length.
  final InitialColors initialColors;

  /// Sets duration of color changing and size changing animation.
  /// If it's null, there won't be any size or color animation
  ///
  /// Important: Color animation only works with initialColors: [InitialColors.random]
  final Duration? bubbleMutationDuration;

  /// Range of sizes to animate bubbles during [bubbleMutationDuration]
  /// Only first and last values are matte).
  ///
  /// Important: Range should be in: [sizeChangingRange.first] <= [bubblesSize] <= [sizeChangingRange.last]
  final List<double>? sizeChangingRange;

  /// Flag restricts color changing animation for [InitialColors.random]
  /// Default value = false
  final bool allowColorChanging;

  /// Bubble size (diameter)
  /// Default value = 400
  final double bubblesSize;

  /// Bubbles' velocity
  /// Default value = 120
  final double velocity;

  /// This is a widget size. You could define it to restrict size.
  /// If it's null, so size of parent will be used.
  /// Important: If there is no size provided, size will be calculated at [addPostFrameCallback] function
  ///            So if you noticed this widget blikning, please, provide a fixed size
  final Size? size;

  /// Child widget to show above the background widget.
  /// Could be just a [SizedBox] if you don't need a child widget.
  final Widget child;

  /// Use it if you want to change blur settings.
  final ImageFilter? customImageFilter;

  /// Use it to mutate from one color set to other color set
  /// Important: Number of colors should be the same as [initialColors] length
  final FluidBackgroundController? controller;

  FluidBackground({
    super.key,
    required this.initialPositions,
    required this.initialColors,
    this.bubbleMutationDuration,
    this.bubblesSize = 400,
    this.velocity = 120,
    this.sizeChangingRange,
    this.allowColorChanging = false,
    this.size,
    this.customImageFilter,
    required this.child,
    required this.controller,
  })  : assert(initialPositions.offsets.length == initialColors.colors.length),
        assert(sizeChangingRange == null ||
            sizeChangingRange.length == 2 &&
                sizeChangingRange.first <= bubblesSize &&
                sizeChangingRange.last >= bubblesSize);

  @override
  State<FluidBackground> createState() => _FluidBackgroundState();
}

class _FluidBackgroundState extends State<FluidBackground> with TickerProviderStateMixin {
  final Random _random = Random();
  final GlobalKey _parentKey = GlobalKey();
  final ValueNotifier<String> uniqueStateNotifier = ValueNotifier<String>('init');

  late Timer mutationTimer;
  late List<Bubble> _bubbles = [];
  bool initted = false;

  List<Offset> get initialOffsets => widget.initialPositions.offsets;

  void mergeToColors(List<Color> colors) {
    if (colors.length != widget.initialColors.colors.length) {
      dev.log("FluidBackground: mutation bubles length not equal to initial colors length");
      return;
    }

    for (int i = 0; i < _bubbles.length; i++) {
      _bubbles[i].color = colors[i];
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!._register(this);
    }

    if (widget.bubbleMutationDuration != null) {
      mutationTimer = createTimer(widget.bubbleMutationDuration!);
    }

    if (widget.size != null) {
      _init(widget.size!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        try {
          final renderBox = _parentKey.currentContext?.findRenderObject() as RenderBox;
          _init(renderBox.size);
        } catch (e) {
          dev.log("FluidBackground: Something went wrong with size calculation", error: e);
        }
      });
    }

    super.initState();
  }

  /// Init function
  _init(Size size) {
    if (initted) {
      return;
    }

    initted = true;
    _bubbles = [];

    for (int i = 0; i < initialOffsets.length; i++) {
      final newPoint = Offset(_random.nextDouble(), _random.nextDouble());

      // Calculating duration
      final s = (calculatePathLength(initialOffsets[i], newPoint, size.width, size.height));
      final v = widget.velocity;
      final t = Duration(seconds: (s / v).toInt());

      final controller = AnimationController(
        vsync: this,
        duration: t,
      );

      final bubble = Bubble(
        Tween<Offset>(
          begin: initialOffsets[i],
          end: newPoint,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        ),
        controller,
        widget.initialColors.colors[i],
        widget.bubblesSize,
      );
      _bubbles.add(bubble);

      uniqueStateNotifier.value = _random.nextInt(10000).toString();

      controller.addListener(() {
        //Full motion restart after last movement
        if (controller.isCompleted) {
          final size =
              widget.size ?? (_parentKey.currentContext?.findRenderObject() as RenderBox).size;
          final newPoint = Offset(_random.nextDouble(), _random.nextDouble());
          final last = bubble.animation.value;

          // Calculating duration
          final s = (calculatePathLength(last, newPoint, size.width, size.height));
          final v = widget.velocity;
          bubble.controller.duration = Duration(seconds: (s / v).toInt());

          bubble.animation = Tween<Offset>(
            begin: last,
            end: newPoint,
          ).animate(
            CurvedAnimation(
              parent: bubble.controller,
              curve: Curves.easeInOut,
            ),
          );

          //Motion restart
          bubble.controller.forward(from: 0.0);
        }
      });

      //First motion start
      bubble.controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    for (var element in _bubbles) {
      element.controller.dispose();
    }
    mutationTimer.cancel();
    uniqueStateNotifier.dispose();
    super.dispose();
  }

  /// Used to restart changing colors and size of bubbles
  Timer createTimer(Duration duration) {
    return Timer(
      duration,
      () {
        mutationTimer.cancel();
        _mutationFunc();
        if (widget.bubbleMutationDuration != null) {
          mutationTimer = createTimer(widget.bubbleMutationDuration!);
        }
      },
    );
  }

  /// Used to change colors and size of bubbles
  _mutationFunc() {
    final colors = generateColors(_bubbles.length);

    for (int i = 0; i < _bubbles.length; i++) {
      if (widget.bubbleMutationDuration != null &&
          widget.initialColors.isRandom &&
          widget.allowColorChanging) {
        _bubbles[i].color = colors[i];
      }

      if (widget.bubbleMutationDuration != null && widget.sizeChangingRange != null) {
        final newSize = widget.sizeChangingRange!.first +
            _random.nextDouble() *
                (widget.sizeChangingRange!.last - widget.sizeChangingRange!.first);

        _bubbles[i].size = newSize;
      }

      uniqueStateNotifier.value = _random.nextInt(10000).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: LayoutBuilder(builder: (context, constraints) {
        final height = widget.size?.height ?? constraints.maxHeight;
        final width = widget.size?.width ?? constraints.maxWidth;
        return SizedBox(
          key: _parentKey,
          height: height,
          width: width,
          child: ValueListenableBuilder(
            valueListenable: uniqueStateNotifier,
            builder: (context, _, child) {
              return Stack(
                children: [
                  for (var bubble in _bubbles)
                    AnimatedBuilder(
                      animation: bubble.animation,
                      builder: (context, child) {
                        double screenHeight = height;
                        double screenWidth = width;

                        return Transform.translate(
                          offset: Offset(
                              xFunc(bubble.animation.value.dx, screenWidth) -
                                  widget.bubblesSize / 2,
                              yFunc(bubble.animation.value.dy, screenHeight) -
                                  widget.bubblesSize / 2),
                          child: AnimatedContainer(
                            duration: widget.bubbleMutationDuration ?? Duration.zero,
                            width: bubble.size,
                            height: bubble.size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  bubble.color,
                                  bubble.color.withOpacity(0),
                                ],
                                stops: const [0.0, 1.0],
                                center: Alignment.center,
                                radius: 0.8,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  child!,
                ],
              );
            },
            child: ClipRRect(
              child: BackdropFilter(
                filter: widget.customImageFilter ??
                    ImageFilter.blur(
                      sigmaX: 100.0,
                      sigmaY: 100.0,
                    ),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// MATH:
  double calculatePathLength(
    Offset start,
    Offset end,
    double maxX,
    double maxY, {
    int steps = 1000,
  }) {
    Offset pointAt(double t) {
      final x = start.dx + t * (end.dx - start.dx);
      final y = start.dy + t * (end.dy - start.dy);
      return Offset(xFunc(x, maxX), yFunc(y, maxY));
    }

    double pathLength = 0.0;
    for (int i = 0; i < steps; i++) {
      final t1 = i / steps;
      final t2 = (i + 1) / steps;

      final p1 = pointAt(t1);
      final p2 = pointAt(t2);

      pathLength += (p2 - p1).distance;
    }

    return pathLength;
  }

  double xFunc(double t, double maxX) {
    return (sin(5 * pi * t) * 0.4 + 0.5) * maxX;
  }

  double yFunc(double t, double maxY) {
    return (sin(2 * pi * t) * 0.4 + 0.5) * maxY;
  }
}
