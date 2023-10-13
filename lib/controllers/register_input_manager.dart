import 'package:flutter/material.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';

/// A class that manages the input of registers for a Register Machine.
///
/// Initially, there are 3 register input fields (4 if R0 is enabled). When the
/// user clicks the "Add" button, a new register input field is added. When the
/// user clicks the "Reset Inputs" button, all register input fields are reset.
///
/// If a register value is not provided, it defaults to 0.
class RegisterInputManager extends ChangeNotifier {
  /// The initial number of register input fields.
  static const initialRegisterInputCount = 4;

  /// The list of [InputManager]s for the register input fields.
  final _registerInputManagers = <InputManager<void>>[];

  /// The [TextEditingController] for the number of steps to show.
  final stepsController = TextEditingController();

  /// The [ScrollController] for the register input fields.
  final scrollController = ScrollController();

  /// The default number of steps to show.
  final defaultSteps = 20;

  /// Whether Register R0 can be set.
  bool _canSetR0 = false;

  /// If not null, show the first [stepsToShow] steps of the simulation.
  bool _isShowingSteps = false;

  /// If the register input fields should be scrolled to the end on post frame.
  bool _scrollToEnd = false;

  /// Get the [TextEditingController] for the register input field at [index].
  TextEditingController getController(int index) =>
      _registerInputManagers[index].textController;

  /// Get whether simulation steps should be shown.
  bool get isShowingSteps => _isShowingSteps;

  /// Get the number of steps to show, if any.
  int? get stepsToShow {
    if (_isShowingSteps) {
      final steps = int.tryParse(stepsController.text) ?? defaultSteps;
      if (steps >= 0) {
        return steps;
      }
    }
    return null;
  }

  /// Get whether Register R0 can be set.
  bool get canSetR0 => _canSetR0;

  /// Set whether Register R0 can be set.
  set canSetR0(bool value) {
    if (_canSetR0 != value) {
      _canSetR0 = value;
      _registerInputManagers[0].textController.text = '';
      notifyListeners();
    }
  }

  /// If the register input fields are reset.
  bool get isRegisterInputResetted =>
      _registerInputManagers.length == initialRegisterInputCount &&
      _registerInputManagers.every((im) => im.textController.text.isEmpty);

  /// The number of register input fields.
  int get registerCount => _registerInputManagers.length;

  /// The list of register values, replacing empty inputs with "0".
  List<String> get registerValues => _registerInputManagers
      .map(
        (im) => im.textController.text.isEmpty ? '0' : im.textController.text,
      )
      .toList();

  /// Initialise the [InputManager]s for the four initial register input fields.
  void initState() {
    for (final im in _registerInputManagers) {
      im.dispose();
    }
    _registerInputManagers.clear();

    _registerInputManagers.addAll(
      List.generate(initialRegisterInputCount, (_) => InputManager()),
    );
    for (final im in _registerInputManagers) {
      im.initState();
      im.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final im in _registerInputManagers) {
      im.dispose();
    }
    _registerInputManagers.clear();
    stepsController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// Reset the register input fields.
  void onReset() {
    initState();
    notifyListeners();
  }

  /// Add a new register input field.
  void onAddRegister() {
    final im = InputManager();
    im.initState();
    im.addListener(notifyListeners);
    _registerInputManagers.add(im);

    /// Scroll to the end of the register input fields to show the new register
    /// on the next frame.
    _scrollToEnd = true;

    notifyListeners();

    // Scroll to the end of the register input fields to show the new register
    // input field.
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  /// Invoked when the show steps checkbox is clicked.
  void onShowStepToggle() {
    _isShowingSteps = !_isShowingSteps;
    notifyListeners();
  }

  /// Invoked when the can set R0 checkbox is clicked.
  void onCanSetR0Toggle() {
    _canSetR0 = !_canSetR0;
    notifyListeners();
  }

  /// Scroll to the end of the register input fields to show the new register.
  ///
  /// This is called after the frame is rendered because the max scroll position
  /// is not updated until after the frame is rendered.
  void onPostFrame() {
    if (_scrollToEnd) {
      _scrollToEnd = false;

      // Scroll to the end of the register input fields to show the new register
      // input field.
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
