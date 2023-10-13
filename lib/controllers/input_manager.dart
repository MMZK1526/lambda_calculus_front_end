import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/utilities/file_io.dart';

/// Manage the input field and the data returned from the callback.
class InputManager<T> extends ChangeNotifier {
  /// The text controller for the input field.
  final textController = TextEditingController();

  /// Whether the input field has any input.
  bool _hasInput = false;

  /// The current searched input.
  String? _currentSearchedInput;

  /// The data returned from the callback.
  T? _data;

  /// The timestamp of the latest request.
  int _timestamp = DateTime.now().millisecondsSinceEpoch;

  bool get hasInput => _hasInput;
  String? get currentSearchedInput => _currentSearchedInput;
  T? get data => _data;

  /// Initialise the internal [textController] and add a listener that triggers
  /// when the emptyness of the input text changes.
  void initState() {
    textController.addListener(() {
      final hasInput =
          textController.text.isNotEmpty || _currentSearchedInput != null;
      if (hasInput != _hasInput) {
        _hasInput = hasInput;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  /// Upload the content of the file to the input field.
  ///
  /// It shows an error dialog if the file is too large.
  Future<void> onUpload(
    BuildContext? context, {
    int maxLength = 1919810,
  }) async {
    try {
      textController.text = await FileIO.uploadToString(maxLength: maxLength);
    } catch (e) {
      if (context != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(MyText.uploadErr.text),
              content: Text('$e'),
              actions: [
                Button(
                  child: Text(MyText.confirm.text),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }
    }
  }

  /// Query using the callback with the input text.
  Future<void> onQuery(FutureOr<T?> Function(String) callback) async {
    final inputText = textController.text;

    // If the input text is empty, restore the current searched input if it
    // exists.
    if (inputText.isEmpty) {
      final curInput = _currentSearchedInput;
      if (curInput != null) {
        textController.text = curInput;
        notifyListeners();
        return;
      }
    }

    final curTimestamp = DateTime.now().millisecondsSinceEpoch;
    _timestamp = curTimestamp;

    // Clear the current data since the new request is sent.
    _data = null;
    notifyListeners();

    final response = await callback(inputText);

    // If the response is not the latest one, ignore it.
    if (curTimestamp < _timestamp) {
      return;
    }

    _currentSearchedInput = inputText;
    _data = response;

    notifyListeners();
  }

  /// Clear the input text and reset the data.
  void onReset() {
    textController.clear();
    _hasInput = false;
    _currentSearchedInput = null;
    _data = null;
    notifyListeners();
  }
}
