class TypeData {
  const TypeData({
    required this.errors,
    this.type,
  });

  final List<String> errors;
  final String? type;

  static const parseError =
      TypeData(errors: ['The lambda term could not be parsed']);

  static const typeError =
      TypeData(errors: ['The lambda term could not be typed']);

  static TypeData fromString(String type) => TypeData(
        errors: [],
        type: type,
      );

  String toMarkdown() {
    if (errors.isNotEmpty) {
      return 'Error during type inference:\n\n${errors.join('\n\n')}';
    }

    return '''
Type: `${type!}`
''';
  }
}
