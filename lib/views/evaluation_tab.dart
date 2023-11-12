// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/components/my_markdown_body.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/my_themes.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';
import 'package:lambda_calculus_front_end/controllers/evaluation_manager.dart';

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
  final _simulationManager = EvaluationManager();
  final _lambdaInputManager = InputManager<String>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _simulationManager.initState();
    _lambdaInputManager.initState();
    _simulationManager.addListener(() => setState(() {}));
    _lambdaInputManager.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _lambdaInputManager.dispose();
    _simulationManager.dispose();
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
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 12.0),
                  Checkbox(
                    value: _simulationManager.useMaxSteps,
                    onChanged: (value) =>
                        _simulationManager.onuseMaxStepToggle(),
                  ),
                  Text(MyText.showFirst.text),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: 60.0,
                      child: TextFormField(
                        enabled: _simulationManager.useMaxSteps,
                        controller: _simulationManager.stepsController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12.0),
                          isDense: true,
                          hintText: '${_simulationManager.defaultSteps}',
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
                        return lambdaRaw;
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
                    enabled: true,
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => null,
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
                    enabled: true,
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
                    onPressed: () => html.window.open(
                      'https://pub.dev/documentation/lambda_calculus/latest/lambda_calculus/ToLambdaExtension/toLambda.html',
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
        ],
      ),
    );
  }
}
