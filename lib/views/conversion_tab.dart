// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:dartz/dartz.dart' as fn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lambda_calculus_front_end/components/button.dart';
import 'package:lambda_calculus_front_end/components/my_markdown_body.dart';
import 'package:lambda_calculus_front_end/constants/my_markdown_texts.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/my_themes.dart';
import 'package:lambda_calculus_front_end/constants/rm_examples.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/controllers/input_manager.dart';
import 'package:lambda_calculus_front_end/models/decode_data.dart';
import 'package:lambda_calculus_front_end/models/encode_data.dart';
import 'package:lambda_calculus_front_end/utilities/file_io.dart';

class ConversionTab extends StatefulWidget {
  const ConversionTab({super.key, this.markdownCallbackBinder});

  /// The callback binder for the [MyMarkdownBody] widgets. It determines the
  /// behaviour for custom links in the Markdown text.
  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  State<ConversionTab> createState() => _ConversionTabState();
}

class _ConversionTabState extends State<ConversionTab>
    with AutomaticKeepAliveClientMixin<ConversionTab> {
  final _decodeInputManager = InputManager<DecodeData>();
  final _encodeRMInputManager = InputManager<EncodeData>();
  final _encodeListOrPairInputManager = InputManager<EncodeData>();

  /// The index of the currently selected RM example.
  int? _currentExampleIndex;

  /// The set of all RM examples.
  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _decodeInputManager.initState();
    _decodeInputManager.addListener(() => setState(() {}));

    _encodeRMInputManager.initState();
    _encodeRMInputManager.addListener(() => setState(() {}));
    _encodeRMInputManager.textController.addListener(() {
      final isExample =
          allExampleRMs.contains(_encodeRMInputManager.textController.text);
      if (_currentExampleIndex != null && !isExample) {
        setState(() => _currentExampleIndex = null);
      }
    });

    _encodeListOrPairInputManager.initState();
    _encodeListOrPairInputManager.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _decodeInputManager.dispose();
    _encodeRMInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final decodeData = _decodeInputManager.data;
    final decodehasValidData = decodeData?.errors.isEmpty == true;
    final encodeRMData = _encodeRMInputManager.data;
    final encodeRMHasValidData = encodeRMData?.errors.isEmpty == true;
    final encodeListOrPairData = _encodeListOrPairInputManager.data;
    final encodeListOrPairHasValidData =
        encodeListOrPairData?.errors.isEmpty == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // MARK: Decode
          MyMarkdownBody(
            callbackBinder: widget.markdownCallbackBinder,
            data: MyMarkdownTexts.simulateUniversalMarkdown,
            fitContent: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _decodeInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _decodeInputManager.currentSearchedInput != null
                          ? 'Click "${MyText.convert.text}" to restore the previous input'
                          : null,
                    ),
                    maxLines: null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: _decodeInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.primary,
                  onPressed: () => null,
                  child: Row(
                    children: [
                      Text(MyText.convert.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: decodehasValidData,
                  colour: Theme.of(context).colorScheme.secondary,
                  onPressed: () => FileIO.saveAsZip(
                    MyText.decodeZip.text,
                    [
                      fn.Tuple2(
                        MyText.responseJSON.text,
                        '${decodeData?.json}',
                      ),
                      fn.Tuple2(
                        MyText.responseMarkdown.text,
                        '${decodeData?.toMarkdown()}',
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(MyText.download.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.download_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: decodehasValidData || _decodeInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.tertiary,
                  onPressed: () => _decodeInputManager.onReset(),
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
          if (decodeData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyMarkdownBody(
                callbackBinder: widget.markdownCallbackBinder,
                selectable: true,
                data: decodeData.toMarkdown(),
                fitContent: false,
              ),
            ),

          // MARK: RM Encode
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MyMarkdownBody(
              data: "",
              callbackBinder: widget.markdownCallbackBinder,
              fitContent: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 36.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: RMExamplesExtension.allExamples().length,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                separatorBuilder: (context, _) => const SizedBox(width: 12.0),
                itemBuilder: (context, index) {
                  final example = RMExamplesExtension.allExamples()[index];
                  return Button(
                    colour: _currentExampleIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      setState(() {
                        _currentExampleIndex = index;
                        _encodeRMInputManager.textController.text = example.rm;
                      });
                    },
                    child: Text(example.text),
                  );
                },
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
                    controller: _encodeRMInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _encodeRMInputManager
                                  .currentSearchedInput?.isNotEmpty ??
                              false
                          ? '# Click "${MyText.convert.text}" to restore the previous input'
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
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => _encodeRMInputManager.onUpload(context),
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
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => null,
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.convert.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.arrow_circle_right_outlined),
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
                    enabled: encodeRMHasValidData,
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      FileIO.saveAsZip(
                        MyText.encodeZip.text,
                        [
                          fn.Tuple2(
                            MyText.responseJSON.text,
                            '${encodeRMData?.json}',
                          ),
                          fn.Tuple2(
                            MyText.responseMarkdown.text,
                            '${encodeRMData?.toMarkdown()}',
                          ),
                        ],
                      );
                    },
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
                        encodeRMHasValidData || _encodeRMInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => _encodeRMInputManager.onReset(),
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
          if (encodeRMData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyMarkdownBody(
                callbackBinder: widget.markdownCallbackBinder,
                data: encodeRMData.toMarkdown(),
                selectable: true,
                fitContent: false,
              ),
            ),

          // MARK: Pair/List Encode
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MyMarkdownBody(
              callbackBinder: widget.markdownCallbackBinder,
              data: "",
              fitContent: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _encodeListOrPairInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _encodeListOrPairInputManager
                                  .currentSearchedInput?.isNotEmpty ??
                              false
                          ? 'Click "${MyText.convert.text}" to restore the previous input'
                          : null,
                    ),
                    maxLines: null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9;, ]')),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  colour: Theme.of(context).colorScheme.primary,
                  onPressed: () => null,
                  child: Row(
                    children: [
                      Text(MyText.convert.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: encodeListOrPairHasValidData,
                  colour: Theme.of(context).colorScheme.secondary,
                  onPressed: () => FileIO.saveAsZip(
                    MyText.decodeZip.text,
                    [
                      fn.Tuple2(
                        MyText.responseJSON.text,
                        '${encodeListOrPairData?.json}',
                      ),
                      fn.Tuple2(
                        MyText.responseMarkdown.text,
                        '${encodeListOrPairData?.toMarkdown()}',
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(MyText.download.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.download_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: encodeListOrPairHasValidData ||
                      _encodeListOrPairInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.tertiary,
                  onPressed: () => _encodeListOrPairInputManager.onReset(),
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
          if (encodeListOrPairData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MyMarkdownBody(
                callbackBinder: widget.markdownCallbackBinder,
                selectable: true,
                data: encodeListOrPairData.toMarkdown(),
                fitContent: false,
              ),
            ),
        ],
      ),
    );
  }
}
