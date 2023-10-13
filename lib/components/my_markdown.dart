// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';

class MyMarkdown extends StatelessWidget {
  /// Creates a scrolling widget that parses and displays Markdown.
  const MyMarkdown({
    super.key,
    required this.data,
    this.selectable = false,
    this.styleSheet,
    this.styleSheetTheme,
    this.syntaxHighlighter,
    this.callbackBinder,
    this.onTapText,
    this.imageDirectory,
    this.blockSyntaxes,
    this.inlineSyntaxes,
    this.extensionSet,
    this.imageBuilder,
    this.checkboxBuilder,
    this.bulletBuilder,
    this.builders = const {},
    this.paddingBuilders = const {},
    this.listItemCrossAxisAlignment =
        MarkdownListItemCrossAxisAlignment.baseline,
    this.padding = const EdgeInsets.all(16.0),
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.softLineBreak = false,
  });

  final String data;

  final bool selectable;

  final MarkdownStyleSheet? styleSheet;

  final MarkdownStyleSheetBaseTheme? styleSheetTheme;

  final SyntaxHighlighter? syntaxHighlighter;

  final CallbackBinder<String>? callbackBinder;

  final VoidCallback? onTapText;

  final String? imageDirectory;

  final List<md.BlockSyntax>? blockSyntaxes;

  final List<md.InlineSyntax>? inlineSyntaxes;

  final md.ExtensionSet? extensionSet;

  final MarkdownImageBuilder? imageBuilder;

  final MarkdownCheckboxBuilder? checkboxBuilder;

  final MarkdownBulletBuilder? bulletBuilder;

  final Map<String, MarkdownElementBuilder> builders;

  final Map<String, MarkdownPaddingBuilder> paddingBuilders;

  final MarkdownListItemCrossAxisAlignment listItemCrossAxisAlignment;

  final EdgeInsets padding;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  final bool shrinkWrap;

  final bool softLineBreak;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      key: key,
      data: data,
      selectable: selectable,
      styleSheet: styleSheet,
      styleSheetTheme: styleSheetTheme,
      syntaxHighlighter: syntaxHighlighter,
      onTapLink: (text, href, title) {
        if (href != null) {
          if (href.startsWith('!!')) {
            callbackBinder?.invokeAt(href.substring(2));
          } else {
            html.window.open(href, 'new tab');
          }
        }
      },
      onTapText: onTapText,
      imageDirectory: imageDirectory,
      blockSyntaxes: blockSyntaxes,
      inlineSyntaxes: inlineSyntaxes,
      extensionSet: extensionSet,
      imageBuilder: imageBuilder,
      checkboxBuilder: checkboxBuilder,
      bulletBuilder: bulletBuilder,
      builders: builders,
      paddingBuilders: paddingBuilders,
      listItemCrossAxisAlignment: listItemCrossAxisAlignment,
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      softLineBreak: softLineBreak,
    );
  }
}
