import 'package:lambda_calculus_front_end/constants/my_text.dart';

class MyMarkdownTexts {
  static const introMarkdown = """
# Lambda Calculus Simulator

Originally created as a project for the Models of Computation and Type Systems for Programming Language modules at Imperial College, this simulator is a web application that allows users to simulate the execution of a Lambda Calculus expression as well as doing basic type inference.

This Web APP uses the [lambda_calculus dart package](https://pub.dev/packages/lambda_calculus) to do the heavy lifting.

""";

  static final typeInferenceMarkdown = """
# Type Inference

This type inference engine uses a basic type system that does not support recursion.

Please type in a Lambda Calculus expression in the input box below and press the "${MyText.typeInfer.text}" button to see the type of the expression.

""";

  static const executionMarkdown = """
""";

  static const convertMarkdown = """
""";

  static const helpMarkdown = """
""";
}
