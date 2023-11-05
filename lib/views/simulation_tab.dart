// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/components/my_markdown_body.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/my_themes.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';

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
  final _lambdaInputManager = InputManager<String>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _lambdaInputManager.initState();
    _lambdaInputManager.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _lambdaInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final simulateData = _lambdaInputManager.data;

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
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    enabled: _lambdaInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => _lambdaInputManager.onQuery(
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
