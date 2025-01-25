import 'package:fluid_background/fluid_background.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FluidBackgroundExampleApp());
}

class FluidBackgroundExampleApp extends StatelessWidget {
  const FluidBackgroundExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FluidBackground(
          initialColors: InitialColors.random(4),
          initialPositions: InitialOffsets.predefined(),
          velocity: 80,
          ballsSize: 400,
          sizeChangingRange: const [300, 600],
          allowColorChanging: true,
          ballMutationDuration: const Duration(seconds: 4),
          child: const SizedBox(),
        ),
      ),
    );
  }
}
