// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/components/my_markdown_body.dart';
import 'package:lambda_calculus_front_end/constants/my_markdown_texts.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/my_themes.dart';
import 'package:lambda_calculus_front_end/constants/rm_examples.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';
import 'package:lambda_calculus_front_end/models/simulate_data.dart';
import 'package:lambda_calculus_front_end/utilities/file_io.dart';

class SimulationTab extends StatefulWidget {
  const SimulationTab({super.key, this.markdownCallbackBinder});

  /// The callback binder for the [MyMarkdownBody] widgets. It determines the
  /// behaviour for custom links in the Markdown text.
  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  State<SimulationTab> createState() => _SimulationTabState();
}

class _SimulationTabState extends State<SimulationTab>
    with AutomaticKeepAliveClientMixin<SimulationTab> {
  final _simulateInputManager = InputManager<SimulateData>();

  /// The index of the currently selected RM example.
  int? _currentExampleIndex;

  /// The set of all RM examples.
  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // widget.markdownCallbackBinder?.withCurrentGroup(MyText.simTab.text, () {
    //   // Bind the download action for the the markdownCallbackBinder.
    //   widget.markdownCallbackBinder?[MyText.download.text] = () {
    //     onDownload(_simulateInputManager.data);
    //   };
    // });

    // _simulateInputManager.initState();
    // _simulateInputManager.addListener(() => setState(() {}));
    // _simulateInputManager.textController.addListener(() {
    //   final isExample =
    //       allExampleRMs.contains(_simulateInputManager.textController.text);
    //   if (_currentExampleIndex != null && !isExample) {
    //     setState(() => _currentExampleIndex = null);
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    _simulateInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final simulateData = _simulateInputManager.data;
    final simulateHasValidData = simulateData?.errors.isEmpty == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [],
      ),
    );
  }
}
