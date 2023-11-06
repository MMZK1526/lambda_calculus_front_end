class LambdaData {
  const LambdaData({
    required this.errors,
    this.lambdas,
  });

  final List<String> errors;
  final List<String>? lambdas;

  static const parseError =
      LambdaData(errors: ['The lambda term could not be parsed']);

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
