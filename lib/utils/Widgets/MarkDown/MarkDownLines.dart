import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SingleLineMarkdownBody extends MarkdownWidget {
  final TextOverflow overflow;
  final int maxLines;

  const SingleLineMarkdownBody(
      {Key key,
        String data,
        MarkdownStyleSheet styleSheet,
        SyntaxHighlighter syntaxHighlighter,
        MarkdownTapLinkCallback onTapLink,
        Directory imageDirectory,
        this.overflow,
        this.maxLines})
      : super(
    key: key,
    data: data,
    styleSheet: styleSheet,
    syntaxHighlighter: syntaxHighlighter,
    onTapLink: onTapLink,
  );

  @override
  Widget build(BuildContext context, List<Widget> children) {
    var richText = _findWidgetOfType<RichText>(children.first);
    print(children.toString());
    if (richText != null) {
      return RichText(
          text: richText.text,
          textAlign: richText.textAlign,
          textDirection: richText.textDirection,
          softWrap: richText.softWrap,
          overflow: this.overflow,
          textScaleFactor: richText.textScaleFactor,
          maxLines: this.maxLines,
          locale: richText.locale);
    }

    return children.first;
  }

  T _findWidgetOfType<T>(Widget widget) {
    if (widget is T) {
      return widget as T;
    }

    if (widget is MultiChildRenderObjectWidget) {
      MultiChildRenderObjectWidget multiChild = widget;
      for (var child in multiChild.children) {
        return _findWidgetOfType<T>(child);
      }
    } else if (widget is SingleChildRenderObjectWidget) {
      SingleChildRenderObjectWidget singleChild = widget;
      return _findWidgetOfType<T>(singleChild.child);
    }

    return null;
  }
}