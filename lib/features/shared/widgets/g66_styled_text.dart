import 'package:flutter/material.dart';

class G66StyledText extends StatelessWidget {
  final String text;
  final TextOverflow overflow;

  final TextStyle normalStyle;
  final TextStyle boldStyle;
  final TextStyle italicStyle;

  final String boldDelimiter;
  final String italicDelimiter;

  const G66StyledText({
    super.key,
    required this.text,
    this.normalStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.boldStyle = const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
    this.italicStyle = const TextStyle(
        fontStyle: FontStyle.italic, fontSize: 16, color: Colors.black),
    this.boldDelimiter = '%',
    this.italicDelimiter = '*',
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: overflow,
      text: TextSpan(
        children: _parseText(text),
      ),
    );
  }

  List<TextSpan> _parseText(String input) {
    final List<TextSpan> spans = [];

    final pattern = RegExp(
      '(${RegExp.escape(boldDelimiter)}.*?${RegExp.escape(boldDelimiter)})|'
      '(${RegExp.escape(italicDelimiter)}.*?${RegExp.escape(italicDelimiter)})',
    );

    final matches = pattern.allMatches(input);

    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
            text: input.substring(currentIndex, match.start),
            style: normalStyle));
      }

      final matchText = match.group(0)!;

      if (matchText.startsWith(boldDelimiter) &&
          matchText.endsWith(boldDelimiter)) {
        spans.add(TextSpan(
          text: matchText.substring(
              boldDelimiter.length, matchText.length - boldDelimiter.length),
          style: boldStyle,
        ));
      } else if (matchText.startsWith(italicDelimiter) &&
          matchText.endsWith(italicDelimiter)) {
        spans.add(TextSpan(
          text: matchText.substring(italicDelimiter.length,
              matchText.length - italicDelimiter.length),
          style: italicStyle,
        ));
      }

      currentIndex = match.end;
    }

    if (currentIndex < input.length) {
      spans.add(
          TextSpan(text: input.substring(currentIndex), style: normalStyle));
    }

    return spans;
  }
}
