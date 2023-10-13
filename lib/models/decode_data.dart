import 'dart:convert';

import 'package:dartz/dartz.dart' as fn;
import 'package:lambda_calculus_front_end/utilities/prelude.dart';

class DecodeData {
  const DecodeData({
    required this.errors,
    this.list,
    this.pair,
    this.line,
    this.regMach,
    this.json,
  });

  final List<String> errors;
  final List<String>? list;
  final String? line;
  final fn.Tuple2<String, String>? pair;
  final String? regMach;
  final String? json;

  static DecodeData fromJSON(dynamic json) {
    try {
      if (json['hasError'] == true) {
        return DecodeData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      final rawPair = (json['decodeToPair'] as List<dynamic>?)?.cast<String>();
      return DecodeData(
        errors: json['errors'] ?? [],
        list: (json['decodeToList'] as List<dynamic>?)?.cast(),
        pair: Prelude.liftNull<List<String>, fn.Tuple2<String, String>>(
          (pair) => fn.Tuple2(pair[0], pair[1]),
          rawPair,
        ),
        line: json['decodeToLine'],
        regMach: json['decodeToRM'],
        json: jsonEncode(json),
      );
    } catch (e) {
      return DecodeData(
        errors: ['Invalid JSON response during decoding', '$e'],
      );
    }
  }

  String toMarkdown() {
    if (errors.isNotEmpty) {
      return 'Error during decoding:\n\n${errors.join('\n\n')}';
    }

    return '''
List|Pair|Line
-|-|-
${list ?? 'none'}|${pair ?? 'none'}|`${line ?? 'none'}`

### Register Machine:
```
${regMach ?? 'none'}
```

* `ARRÊT` means `HALT`. These two keywords are interchangeable in our syntax
''';
  }
}
