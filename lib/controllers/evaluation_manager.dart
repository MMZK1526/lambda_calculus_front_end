import 'package:flutter/widgets.dart';

class EvaluationManager extends ChangeNotifier {
  /// The default number of steps to show.
  static const defaultSteps = 20;

  /// The maximum number of steps to show.
  int _maxSteps = 20;

  int? getMaxSteps() => _useMaxSteps ? _maxSteps : null;

  set maxSteps(int value) {
    _maxSteps = value;
    notifyListeners();
  }

  /// If true, show the first [maxSteps] steps of the evaluation.
  bool _useMaxSteps = true;

  bool get useMaxSteps => _useMaxSteps;

  /// The [TextEditingController] for the number of steps to show.
  final stepsController = TextEditingController();

  /// Initialisastion. Does nothing since there is no state to initialise.
  void initState() {}

  @override
  void dispose() {
    stepsController.dispose();
    super.dispose();
  }

  /// Invoked when the show first N steps checkbox is clicked.
  void onUseMaxStepToggle() {
    _useMaxSteps = !_useMaxSteps;
    notifyListeners();
  }
}
