// ignore_for_file: unnecessary_string_escapes

import 'package:lambda_calculus_front_end/constants/my_text.dart';

class MyMarkdownTexts {
  static final introMarkdown = """
# Lambda Calculus Simulator

Originally created as a project for the Models of Computation and Type Systems for Programming Language modules at Imperial College, this simulator is a web application that allows users to evaluate the execution of a Lambda Calculus expression as well as doing basic type inference.

This Web APP uses the [lambda_calculus dart package](https://pub.dev/packages/lambda_calculus) to do the heavy lifting.

## Features

TODO: The [${MyText.evalTab.text}](!!evaluation) tab supports evaluating a lambda term by the given number of steps or to the normal form. It supports three evaluation strategies:
1. Full reduction. Call by name and attempts to reduce everything.
2. Call by name. Call by name, does not reduce within abstraction. Usually corresponds to "lazy evaluation".
3. Call by value. Call by value, does not reduce within abstraction. Usually corresponds to "eager evaluation".

The [${MyText.typeTab.text}](!!type-inference) tab supports type inference for a lambda term. It supports the vanilla Church type system without recursion.

## Syntax

Here is the semi-formal grammar of the supported syntax.

```
<lambda> ::= <variable> | <abstraction> | <application>
<variable> ::= <identifier> | <de-bruijn-index>
<abstraction> ::= <lambda-symbol> [<variable>] <dot-symbol> <lambda>
<application> ::= <lambda> <lambda>
<lambda-symbol> ::= (λ|/|\\) -- lambda, slash, or backslash
<dot-symbol> ::= (\.) | (->) -- A single dot or an arrow
<identifier> ::= ([a-zA-Z][a-zA-Z0-9]*) -- Alpha-numeric strings that do not start with a digit
<de-bruijn-index> ::= ([0-9]+) -- De Bruijn index
```

In addition to the above, spaces are ignored and parentheses are used to determine the precedence of operations. For example, `λx.x x` is parsed as `λx.(x x)`, not `(λx.x) x`.

As an example, let us start from the "succ" term `λa. λb. λc. b (a b c)`. The term itself can be successfully parsed, but we can also do the following modifications without affecting the parse result:

- Remove spaces: `λa.λb.λc.b(a b c)` Note that the space in `(a b c)` cannot be removed since otherwise it will treat `abc` as a single variable.
- Use other symbols for "λ": `/a.\\b./c.b(a b c)`, we support slash and backslash as well.
- Changing the doc to an arrow: `λa b c -> b (a b c)`.
- Use De Bruijn indices for variables: `λa. λb. λc. 2 (3 2 1)`. Here `1`, `2`, and `3` are the De Bruijn indices for `c`, `b`, and `a`.
- If we are only using the De Bruijn indices, we can omit the variable declaration: `λλλ2 (3 2 1)`.

""";

  static final typeInferenceMarkdown = """
# Type Inference

This type inference engine uses a basic type system that does not support recursion.

The type system is very simple:

```
<type> ::= <type> -> <type> | <type-variable>
```

Please type in a Lambda Calculus expression in the input box below and press the "${MyText.typeInfer.text}" button to see the type of the expression.

""";

  static final evaluationMarkdown = """
# Lambda Evaluation

Enter a Lambda term in the input box below to start evaluating it. You can also choose the evaluation strategy and the number of steps to evaluate. Alternatively, you can select from the provided examples (TODO).

Click the [${MyText.help.text}](!!help) button for syntax guides.

The "Show first XXX steps" checkbox allows you to show only the first XXX steps of the evaluation. The checkbox is checked by default, and when unchecked, the evaluation will continue until the normal form is reached, which may cause the website to freeze if there is no normal form.

""";
}
