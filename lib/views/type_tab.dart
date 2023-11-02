import 'package:flutter/material.dart';
import 'package:lambda_calculus/lambda_calculus.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/components/my_markdown_body.dart';
import 'package:lambda_calculus_front_end/constants/my_markdown_texts.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/rm_examples.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';
import 'package:lambda_calculus_front_end/models/type_data.dart';

class TypeTab extends StatefulWidget {
  const TypeTab({super.key, this.markdownCallbackBinder});

  /// The callback binder for the [MyMarkdownBody] widgets. It determines the
  /// behaviour for custom links in the Markdown text.
  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  State<TypeTab> createState() => _TypeTabState();
}

class _TypeTabState extends State<TypeTab>
    with AutomaticKeepAliveClientMixin<TypeTab> {
  final _lambdaInputManager = InputManager<TypeData>();

  /// The index of the currently selected Lambda example.
  int? _currentExampleIndex;

  /// The set of all Lambda examples.
  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _lambdaInputManager.initState();
    _lambdaInputManager.addListener(() => setState(() {}));

    _lambdaInputManager.textController.addListener(() {
      final isExample =
          allExampleRMs.contains(_lambdaInputManager.textController.text);
      if (_currentExampleIndex != null && !isExample) {
        setState(() => _currentExampleIndex = null);
      }
    });
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

    final lambdaTypeResult = _lambdaInputManager.data;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // MARK: Lambda input
          MyMarkdownBody(
            callbackBinder: widget.markdownCallbackBinder,
            data: MyMarkdownTexts.typeInferenceMarkdown,
            fitContent: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _lambdaInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _lambdaInputManager.currentSearchedInput != null
                          ? 'Click "${MyText.typeInfer.text}" to restore the previous input'
                          : null,
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: _lambdaInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    _lambdaInputManager.onQuery((input) {
                      final lambda = input.toLambda();
                      if (lambda == null) {
                        return TypeData.parseError;
                      }
                      final type = lambda.findType();
                      if (type == null) {
                        return TypeData.typeError;
                      }

                      return TypeData.fromString(type.toString());
                    });
                  },
                  child: Row(
                    children: [
                      Text(MyText.typeInfer.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                const SizedBox(width: 12.0),
                Button(
                  enabled: lambdaTypeResult?.errors.isEmpty == true ||
                      _lambdaInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.tertiary,
                  onPressed: () => _lambdaInputManager.onReset(),
                  child: Row(
                    children: [
                      Text(MyText.reset.text),
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
          if (lambdaTypeResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyMarkdownBody(
                callbackBinder: widget.markdownCallbackBinder,
                selectable: true,
                data: lambdaTypeResult.toMarkdown(),
                fitContent: false,
              ),
            ),
        ],
      ),
    );
  }
}
