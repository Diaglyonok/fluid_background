part of 'fluid_background.dart';

class FluidBackgroundController {
  late final _FluidBackgroundState _currentState;

  void _register(_FluidBackgroundState state) {
    _currentState = state;
  }

  void mutateToColors(List<Color> colors) {
    if (!_currentState.mounted) {
      return;
    }

    _currentState.mergeToColors(colors);
  }
}
