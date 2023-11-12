import 'package:lambda_calculus/lambda_calculus.dart';

class LambdaData {
  const LambdaData({
    required this.errors,
    this.lambdas,
  });

  final List<String> errors;
  final List<String>? lambdas;

  static const parseError =
      LambdaData(errors: ['The lambda term could not be parsed']);

  LambdaData.buildData({
    required Lambda baseLambda,
    int? maxSteps,
    LambdaEvaluationType evaluationType = LambdaEvaluationType.fullReduction,
  })  : errors = <String>[],
        lambdas = <String>[] {
    var curStep = 0;
    Lambda? curLambda = baseLambda;
    lambdas!.add(baseLambda.toString());

    while (curLambda != null && (maxSteps == null || curStep < maxSteps)) {
      lambdas!.add(curLambda.toString());
      curLambda = curLambda.eval1(evalType: evaluationType);
      curStep += 1;
    }
  }

  String toMarkdown() {
    if (errors.isNotEmpty) {
      return 'Error during evaluation:\n\n${errors.join('\n\n')}';
    }

    final sb = StringBuffer();
    sb.write('Step|Term\n');
    sb.write('-|-\n');

    for (var i = 0; i < lambdas!.length; i += 1) {
      sb.write('$i|`${lambdas![i]}`\n');
    }

    return sb.toString();
  }
}
