import 'dart:convert';

import 'package:dartz/dartz.dart' as fn;
import 'package:lambda_calculus_front_end/utilities/prelude.dart';

class EncodeData {
  const EncodeData({
    required this.errors,
    this.list,
    this.pair,
    this.regMach,
    this.lines,
    this.json,
  });

  final List<String> errors;
  final fn.Option<String>? list;
  final fn.Option<String>? pair;
  final fn.Option<String>? regMach;
  final List<fn.Option<String>>? lines;
  final String? json;

  static EncodeData fromJSON(dynamic json) {
    fn.Option<String> toOptionalNum(Map<String, dynamic> encodeNum) {
      if (encodeNum['isTooBig'] == true) {
        return const fn.None();
      }

      return fn.Some(encodeNum['num']);
    }

    try {
      if (json['hasError'] == true) {
        return EncodeData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      return EncodeData(
        errors: json['errors'] ?? [],
        list: Prelude.liftNull<Map<String, dynamic>, fn.Option<String>>(
          toOptionalNum,
          json['encodeFromList'],
        ),
        pair: Prelude.liftNull<Map<String, dynamic>, fn.Option<String>>(
          toOptionalNum,
          json['encodeFromPair'],
        ),
        regMach: Prelude.liftNull<Map<String, dynamic>, fn.Option<String>>(
          toOptionalNum,
          json['encodeFromRM'],
        ),
        lines: (json['encodeToLine'] as List<dynamic>?)
            ?.cast()
            .map((line) => toOptionalNum(line))
            .toList(),
        json: jsonEncode(json),
      );
    } catch (e) {
      return EncodeData(
        errors: ['Invalid JSON response during encoding', '$e'],
      );
    }
  }

  String toMarkdown() {
    String showOptionalNumber(fn.Option<String> num) {
      return num.fold(
        () => '[TOO BIG]',
        (num) => num,
      );
    }

    if (errors.isNotEmpty) {
      return 'Error during encoding:\n\n${errors.join('\n\n')}';
    }

    final sb = StringBuffer();

    if (lines != null) {
      final lineStr = Iterable<int>.generate(lines!.length)
          .toList()
          .map((ix) => '$ix|${showOptionalNumber(lines![ix])}')
          .join('\n');
      sb.write('''
### Line-by-line Encoding:
Line Number|Gödel Number
-|-
$lineStr
''');
    }

    if (regMach != null) {
      sb.write('''
### Gödel Number:
${showOptionalNumber(regMach!)}
''');
    }

    if (pair != null) {
      sb.write('''
### Encoding from Pair:
${showOptionalNumber(pair!)}
''');
    }

    if (list != null) {
      sb.write('''
### Encoding from List:
${showOptionalNumber(list!)}
''');
    }

    return sb.toString();
  }
}
