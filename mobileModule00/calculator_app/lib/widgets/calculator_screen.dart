import 'package:flutter/material.dart';

import '../models/calculator_key.dart';
import 'calculator_display.dart';
import 'calculator_keypad.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({
    required this.expression,
    required this.result,
    required this.keys,
    required this.onKeyPressed,
    super.key,
  });

  final String expression;
  final String result;
  final List<CalculatorKey> keys;
  final ValueChanged<CalculatorKey> onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator'), centerTitle: true),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth < 600
                    ? constraints.maxWidth
                    : 600,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                child: Column(
                  children: [
                    CalculatorDisplay(expression: expression, result: result),
                    const SizedBox(height: 14),
                    Expanded(
                      child: CalculatorKeypad(
                        keys: keys,
                        onKeyPressed: onKeyPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
