class TypeData {
  const TypeData({
    required this.errors,
    this.type,
  });

  final List<String> errors;
  final String? type;

  static TypeData fromJSON(dynamic json) {
    try {
      if (json['hasError'] == true) {
        return TypeData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      return TypeData(
        errors: json['errors'] ?? [],
        type: json['type'],
      );
    } catch (e) {
      return TypeData(
        errors: ['Invalid JSON response during type inference', '$e'],
      );
    }
  }

  String toMarkdown() {
    if (errors.isNotEmpty) {
      return 'Error during type inference:\n\n${errors.join('\n\n')}';
    }

    return '''
Type: `${type!}`
''';
  }
}