
# Fluid Background 🎨🌊

A Flutter package for creating a mesmerizing, animated fluid-like background with colorful floating blobs. Enhance your app's UI by adding this visually appealing effect as a background with built-in blur support.

---

## Features ✨

- **Dynamic floating bubbles**: Smooth animations of colorful bubbles floating across the background.
- **Blur effect**: Integrated background blur for a dreamy, fluid look.
- **Customizable**: Adjust colors, number of blobs, animation speed, and more.
- **Lightweight**: Designed with performance in mind.
- **For pny platform**: Designed to be used in any platform, doesn't have any dependencies ecxept flutter

---

## Installation 📦

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  fluid_background: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Usage 🚀

Simply wrap your widget with the `FluidBackground` widget and adjust sSettings:

```dart
import 'package:fluid_background/fluid_background.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FluidBackground(
          initialColors: InitialColors.random(4),
          initialPositions: InitialOffsets.predefined(),
          velocity: 80,
          bubblesSize: 400,
          sizeChangingRange: const [300, 600],
          allowColorChanging: true,
          bubbleMutationDuration: const Duration(seconds: 4),
          child: Center(
            //Any widget here
          ),
        ),
      ),
    );
  }
}
```

---

## Customization 🛠

You can customize the `FluidBackground` widget to fit your needs:

```dart
FluidBackground(
  initialColors: InitialColors.random, // Define initial colors of blobs
  initialPositions: InitialOffsets.predefined, // Define initial positions of blobs
  bubbleMutationDuration: Duration(seconds: 4), // Duration for bubble mutation animations
  sizeChangingRange: [300.0, 500.0], // Size range for animation
  allowColorChanging: true, // Allow color changing animation
  bubblesSize: 400, // Default bubble size (diameter)
  velocity: 120, // bubble velocity
  size: Size(800, 600), // Fixed widget size
  child: YourWidget(), // Your content goes here
)
```

### Parameters:
| Property             | Type                | Description                                                                                                                                         | Default             |
|----------------------|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| `initialPositions`   | `InitialOffsets`    | Defines the initial positions of blobs. Options: `custom`, `predefined`, `random`. Positions are modified with sin() and must match `initialColors`. | `InitialOffsets.random` |
| `initialColors`      | `InitialColors`     | Defines the initial colors of blobs. Options: `custom`, `predefined`, `random`. Must match `initialPositions` length.                                | `InitialColors.random`  |
| `bubbleMutationDuration` | `Duration?`       | Duration for size and color animations. Only works with `InitialColors.random`.                                                                     | `null`              |
| `sizeChangingRange`  | `List<double>?`     | Range of sizes for animation. Must include the current bubble size.                                                                                   | `null`              |
| `allowColorChanging` | `bool`              | Whether to allow color changes during animations when using `InitialColors.random`.                                                                 | `false`             |
| `bubblesSize`          | `double`            | Diameter of the blobs.                                                                                                                              | `400`               |
| `velocity`           | `double`            | Velocity of the blobs.                                                                                                                              | `120`               |
| `size`               | `Size?`             | Fixed size of the widget. If `null`, the parent size will be used.                                                                                  | `null`              |
| `child`              | `Widget`            | Child widget displayed above the fluid background.                                                                                                  | `null`              |

---

## Example App 📱

Check out the full example in the [example/](example/) directory for more usage scenarios.

---

## Screenshots 🖼️

| Example 1                                | Example 2                                |
|-----------------------------------------|-----------------------------------------|
| ![Example 1](https://via.placeholder.com/200) | ![Example 2](https://via.placeholder.com/200) |

---

## Contributions 🤝

Contributions are welcome! If you find a bug or have a feature request, feel free to open an issue or submit a pull request.

---

## License 📝

This package is distributed under the [Apache 2.0 License].

---

## Support ❤️

If you enjoy using this package, please consider giving it a ⭐ on [pub.dev](https://pub.dev/packages/fluid_background)!
