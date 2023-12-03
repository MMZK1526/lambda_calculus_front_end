// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lambda_calculus/lambda_calculus.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/components/button_group.dart';
import 'package:lambda_calculus_front_end/components/my_markdown_body.dart';
import 'package:lambda_calculus_front_end/constants/my_markdown_texts.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/my_themes.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';
import 'package:lambda_calculus_front_end/controllers/evaluation_manager.dart';
import 'package:lambda_calculus_front_end/models/lambda_data.dart';
import 'package:lambda_calculus_front_end/utilities/file_io.dart';

class EvaluationTab extends StatefulWidget {
  const EvaluationTab({super.key, this.markdownCallbackBinder});

  /// The callback binder for the [MyMarkdownBody] widgets. It determines the
  /// behaviour for custom links in the Markdown text.
  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  State<EvaluationTab> createState() => _EvaluationTabState();
}

class _EvaluationTabState extends State<EvaluationTab>
    with AutomaticKeepAliveClientMixin<EvaluationTab> {
  final _evaluationManager = EvaluationManager();
  final _lambdaInputManager = InputManager<LambdaData>();

  @override
  bool get wantKeepAlive => true;

  void help() {
    html.window.open(
      'https://pub.dev/documentation/lambda_calculus/latest/lambda_calculus/ToLambdaExtension/toLambda.html',
      'new tab',
    );
  }

  @override
  void initState() {
    _evaluationManager.initState();
    _lambdaInputManager.initState();
    _evaluationManager.addListener(() => setState(() {}));
    _lambdaInputManager.addListener(() => setState(() {}));

    widget.markdownCallbackBinder?.withCurrentGroup(MyText.evalTab.text, () {
      // Bind the markdownCallbackBinder to the tabs.
      widget.markdownCallbackBinder?['help'] = help;
    });

    super.initState();
  }

  @override
  void dispose() {
    _lambdaInputManager.dispose();
    _evaluationManager.dispose();
    widget.markdownCallbackBinder?.dispose(MyText.evalTab.text);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final evaluateData = _lambdaInputManager.data;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          MyMarkdownBody(
            callbackBinder: widget.markdownCallbackBinder,
            data: MyMarkdownTexts.evaluationMarkdown,
            fitContent: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: MyTheme.monospaceTheme.theme.textTheme.bodyLarge,
                    controller: _lambdaInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _lambdaInputManager.currentSearchedInput != null
                          ? '# Click "${MyText.evaluate.text}" to restore the previous input'
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
              height: 36.0,
              child: Row(
                children: [
                  ButtonGroup(
                    onPressed: (i) {
                      switch (i) {
                        case 0:
                          _evaluationManager.evaluationType =
                              LambdaEvaluationType.fullReduction;
                          break;
                        case 1:
                          _evaluationManager.evaluationType =
                              LambdaEvaluationType.callByName;
                          break;
                        case 2:
                          _evaluationManager.evaluationType =
                              LambdaEvaluationType.callByValue;
                          break;
                      }
                    },
                    children: [
                      Text(MyText.fullReduction.text),
                      Text(MyText.callByName.text),
                      Text(MyText.callByValue.text),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 12.0),
                  Checkbox(
                    value: _evaluationManager.useMaxSteps,
                    onChanged: (value) =>
                        _evaluationManager.onUseMaxStepToggle(),
                  ),
                  Text(MyText.showFirst.text),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: 60.0,
                      child: TextFormField(
                        enabled: _evaluationManager.useMaxSteps,
                        onChanged: (value) => _evaluationManager.maxSteps =
                            int.tryParse(value) ??
                                EvaluationManager.defaultSteps,
                        controller: _evaluationManager.stepsController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          isDense: true,
                          hintText: '${EvaluationManager.defaultSteps}',
                        ),
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),
                  Text(MyText.steps.text),
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
                    enabled: _lambdaInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => _lambdaInputManager.onQuery(
                      (lambdaRaw) {
                        final lambda = lambdaRaw.toLambda();

                        if (lambda == null) {
                          return LambdaData.parseError;
                        }
                        final result = LambdaData.buildData(
                          baseLambda: lambda,
                          maxSteps: _evaluationManager.getMaxSteps(),
                          evaluationType: _evaluationManager.evaluationType,
                        );
                        return result;
                      },
                    ),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.evaluate.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.computer_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: Button(
                    enabled: evaluateData?.errors.isEmpty == true,
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => FileIO.saveFromString(
                      MyText.responseMarkdown.text,
                      '${evaluateData?.toMarkdown()}',
                    ),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    enabled: evaluateData?.errors.isEmpty == true ||
                        _lambdaInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => _lambdaInputManager.onReset(),
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
                    onPressed: help,
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
          if (evaluateData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyMarkdownBody(
                callbackBinder: widget.markdownCallbackBinder,
                selectable: true,
                data: evaluateData.toMarkdown(),
                fitContent: false,
              ),
            ),
        ],
      ),
    );
  }
}
