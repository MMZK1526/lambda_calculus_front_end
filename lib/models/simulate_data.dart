import 'dart:convert';
import 'dart:math';

class SimulateData {
  const SimulateData({
    required this.errors,
    this.steps,
    this.registerValues,
    this.pcSnapshots,
    this.registerSnapshots,
    this.json,
  });

  final List<String> errors;
  final String? steps;
  final List<String>? registerValues;
  final List<String>? pcSnapshots;
  final List<List<String>>? registerSnapshots;
  final String? json;

  static SimulateData fromJSON(dynamic json) {
    try {
      if (json['hasError'] == true) {
        return SimulateData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      return SimulateData(
        errors: json['errors'] ?? [],
        steps: json['steps'],
        registerValues: (json['registerValues'] as List<dynamic>?)?.cast(),
        pcSnapshots: (json['pcSnapshots'] as List<dynamic>?)?.cast(),
        registerSnapshots: (json['registerSnapshots'] as List<dynamic>?)
            ?.map((row) => (row as List<dynamic>).cast<String>())
            .toList()
            .cast(),
        json: jsonEncode(json),
      );
    } catch (e) {
      return SimulateData(
        errors: ['Invalid JSON response during decoding', '$e'],
      );
    }
  }

  /// When [showAllSteps] is false (by default), it shows up to 50 steps.
  String toMarkdown({bool showAllSteps = false}) {
    if (errors.isNotEmpty) {
      return 'Error during simulation:\n\n${errors.join('\n\n')}';
    }

    final sb = StringBuffer();

    if (steps != null) {
      sb.write('### Total number of execution steps:\n');
      sb.write('$steps\n');
    }

    if (registerValues != null) {
      sb.write('### Final Register Values:\n');
      sb.write('Register|Value\n');
      sb.write('-|-\n');
      for (var i = 0; i < registerValues!.length; i++) {
        sb.write('R$i|${registerValues![i]}\n');
      }
    }

    if (pcSnapshots != null &&
        registerSnapshots != null &&
        registerSnapshots!.isNotEmpty) {
      final shownSteps =
          showAllSteps ? pcSnapshots!.length : min(50, pcSnapshots!.length);
      sb.write('### Execution Details:\n');
      sb.write('Step|PC');
      for (var i = 0; i < registerSnapshots![0].length; i++) {
        sb.write('|R$i');
      }
      sb.write('\n');
      sb.write('-|-');
      for (var i = 0; i < registerSnapshots![0].length; i++) {
        sb.write('|-');
      }
      sb.write('\n');
      for (var i = 0; i < shownSteps; i++) {
        sb.write('${i + 1}|${pcSnapshots![i]}');
        for (final reg in registerSnapshots![i]) {
          sb.write('|$reg');
        }
        sb.write('\n');
      }

      if (shownSteps < pcSnapshots!.length) {
        sb.write('...|...');
        for (var i = 0; i < registerSnapshots![0].length; i++) {
          sb.write('|...');
        }
        sb.write('\n\n');
        sb.write(
          '* A maximum of 50 steps are shown here. The rest are available by clicking the [Download](!!Download) button.\n',
        );
      }
    }

    return sb.toString();
  }
}
