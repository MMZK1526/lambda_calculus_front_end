import 'package:flutter/material.dart';
import 'package:lambda_calculus_front_end/components/button.dart';

class ButtonGroup extends StatefulWidget {
  const ButtonGroup({
    super.key,
    required this.onPressed,
    required this.children,
    this.initialSelection = 0,
  });

  final Function(int index)? onPressed;

  final List<Widget> children;

  final int initialSelection;

  @override
  State<ButtonGroup> createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  late int _selection = widget.initialSelection;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.children.indexed
          .map(
            (entry) => Button(
              onPressed: () {
                widget.onPressed?.call(entry.$1);
                setState(() => _selection = entry.$1);
              },
              colour: entry.$1 == _selection
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              borderRadius: 0.0,
              child: entry.$2,
            ),
          )
          .toList(),
    );
  }
}
