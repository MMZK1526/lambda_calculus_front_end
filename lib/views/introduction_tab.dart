import 'package:flutter/widgets.dart';
import 'package:lambda_calculus_front_end/components/my_markdown.dart';
import 'package:lambda_calculus_front_end/constants/my_markdown_texts.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';

class IntroductionTab extends StatelessWidget {
  const IntroductionTab({super.key, this.markdownCallbackBinder});

  /// The callback binder for the [MyMarkdown] widget. It determines the
  /// behaviour for custom links in the Markdown text.
  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  Widget build(BuildContext context) {
    return MyMarkdown(
      data: MyMarkdownTexts.introMarkdown,
      callbackBinder: markdownCallbackBinder,
    );
  }
}
