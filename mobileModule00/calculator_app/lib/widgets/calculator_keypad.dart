import 'package:flutter/material.dart';

import '../models/calculator_key.dart';
import 'calculator_key_button.dart';

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    required this.keys,
    required this.onKeyPressed,
    super.key,
  });

  final List<CalculatorKey> keys;
  final ValueChanged<CalculatorKey> onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final key = keys[index];
        if (key.kind == CalculatorKeyKind.empty) {
          return const SizedBox.shrink();
        }

        return CalculatorKeyButton(
          calculatorKey: key,
          onPressed: () => onKeyPressed(key),
        );
      },
    );
  }
}
