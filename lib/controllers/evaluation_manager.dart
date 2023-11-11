import 'package:flutter/widgets.dart';

class EvaluationManager extends ChangeNotifier {
  /// The default number of steps to show.
  final defaultSteps = 20;

  /// If not null, show the first [useMaxSteps] steps of the evaluation.
  bool _useMaxSteps = false;

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
  void onuseMaxStepToggle() {
    _useMaxSteps = !_useMaxSteps;
    notifyListeners();
  }
}
