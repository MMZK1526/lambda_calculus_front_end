// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:dartz/dartz.dart' as fn;
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
import 'package:lambda_calculus_front_end/controllers/register_input_manager.dart';
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
  final _registerInputManager = RegisterInputManager();

  /// The index of the currently selected RM example.
  int? _currentExampleIndex;

  /// The set of all RM examples.
  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;

  /// Downloads the JSON and Markdown responses for the simulation result.
  void onDownload(SimulateData? data) async {
    FileIO.saveAsZip(
      MyText.simlateZip.text,
      [
        fn.Tuple2(MyText.responseJSON.text, '${data?.json}'),
        fn.Tuple2(
          MyText.responseMarkdown.text,
          '${data?.toMarkdown(showAllSteps: true)}',
        ),
      ],
    );
  }

  @override
  void initState() {
    widget.markdownCallbackBinder?.withCurrentGroup(MyText.simTab.text, () {
      // Bind the download action for the the markdownCallbackBinder.
      widget.markdownCallbackBinder?[MyText.download.text] = () {
        onDownload(_simulateInputManager.data);
      };
    });

    _simulateInputManager.initState();
    _simulateInputManager.addListener(() => setState(() {}));
    _simulateInputManager.textController.addListener(() {
      final isExample =
          allExampleRMs.contains(_simulateInputManager.textController.text);
      if (_currentExampleIndex != null && !isExample) {
        setState(() => _currentExampleIndex = null);
      }
    });

    _registerInputManager.initState();
    _registerInputManager.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _simulateInputManager.dispose();
    _registerInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // This is required to ensure that _registerInputManager is updated after
    // the ListView has been rebuilt. When it updates, it will scroll to the
    // end of the register input list if a new register has been added.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _registerInputManager.onPostFrame();
    });

    final simulateData = _simulateInputManager.data;
    final simulateHasValidData = simulateData?.errors.isEmpty == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          MyMarkdownBody(
            callbackBinder: widget.markdownCallbackBinder,
            data: MyMarkdownTexts.simulateMarkdown,
            fitContent: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 36.0,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: RMExamplesExtension.allExamples().length,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      separatorBuilder: (context, _) =>
                          const SizedBox(width: 12.0),
                      itemBuilder: (context, index) {
                        final example =
                            RMExamplesExtension.allExamples()[index];
                        return Button(
                          colour: _currentExampleIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            setState(() {
                              _currentExampleIndex = index;
                              _simulateInputManager.textController.text =
                                  example.rm;
                            });
                          },
                          child: Text(example.text),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Checkbox(
                    value: _registerInputManager.isShowingSteps,
                    onChanged: (value) =>
                        _registerInputManager.onShowStepToggle(),
                  ),
                  Text(MyText.showFirst.text),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: 60.0,
                      child: TextFormField(
                        enabled: _registerInputManager.isShowingSteps,
                        controller: _registerInputManager.stepsController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12.0),
                          isDense: true,
                          hintText: '${_registerInputManager.defaultSteps}',
                        ),
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),
                  Text(MyText.steps.text),
                  const SizedBox(width: 12.0),
                  Checkbox(
                    value: _registerInputManager.canSetR0,
                    onChanged: (value) => _registerInputManager.canSetR0 =
                        value ?? _registerInputManager.canSetR0,
                  ),
                  Text(MyText.startFromR0.text),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: MyTheme.monospaceTheme.theme.textTheme.bodyLarge,
                    controller: _simulateInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _simulateInputManager.currentSearchedInput !=
                              null
                          ? '# Click "${MyText.simulate.text}" to restore the previous input'
                          : null,
                    ),
                    minLines: 7,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 64.0,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: _registerInputManager.scrollController,
                      itemCount: _registerInputManager.registerCount,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                          width: !_registerInputManager.canSetR0 && index == 0
                              ? 0.0
                              : 24.0),
                      itemBuilder: (context, index) {
                        if (!_registerInputManager.canSetR0 && index == 0) {
                          return const SizedBox.shrink();
                        }
                        return SizedBox(
                          width: 240.0,
                          child: Row(
                            children: [
                              Text('R$index: '),
                              Expanded(
                                child: TextFormField(
                                  controller: _registerInputManager
                                      .getController(index),
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                  ),
                                  maxLines: null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  Button(
                    enabled: true,
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => _registerInputManager.onAddRegister(),
                    child: Row(
                      children: [
                        Text(MyText.addRegister.text),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.add_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Button(
                    enabled: !_registerInputManager.isRegisterInputResetted,
                    colour: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => _registerInputManager.onReset(),
                    child: Row(
                      children: [
                        Text(MyText.resetInputs.text),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.restore_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => _simulateInputManager.onUpload(context),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.upload.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.upload_file_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: Button(
                    enabled: _simulateInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => _simulateInputManager.onQuery(
                      (rm) => null,
                    ),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.simulate.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.computer_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    enabled: simulateHasValidData,
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => onDownload(simulateData),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.download.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.download_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: Button(
                    enabled:
                        simulateHasValidData || _simulateInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => _simulateInputManager.onReset(),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.reset.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.restore_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: Button(
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => html.window.open(
                      'https://github.com/MMZK1526/Haskell-RM#Syntax',
                      'new tab',
                    ),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.help.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.help_outline_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (simulateData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyMarkdownBody(
                callbackBinder: widget.markdownCallbackBinder,
                selectable: true,
                data: simulateData.toMarkdown(),
                fitContent: false,
              ),
            ),
        ],
      ),
    );
  }
}
