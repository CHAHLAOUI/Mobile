import 'package:flutter/material.dart';

import '../widgets/calculator_display.dart';
import '../widgets/calculator_key_button.dart';

class CalculatorLayoutPage extends StatelessWidget {
  const CalculatorLayoutPage({super.key});

  static const _buttons = <String>[
    'AC',
    'C',
    '\u00F7',
    '\u00D7',
    '7',
    '8',
    '9',
    '\u2212',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '=',
    '0',
    '.',
    '',
    '',
  ];

  bool _isOperator(String label) =>
      const {'\u00F7', '\u00D7', '\u2212', '+', '='}.contains(label);

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
                maxWidth: constraints.maxWidth < 640
                    ? constraints.maxWidth
                    : 640,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  children: [
                    const CalculatorDisplay(expression: '0', result: '0'),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        itemCount: _buttons.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.25,
                            ),
                        itemBuilder: (context, index) {
                          final label = _buttons[index];
                          if (label.isEmpty) return const SizedBox.shrink();

                          return CalculatorKeyButton(
                            label: label,
                            isOperator: _isOperator(label),
                            isUtility: label == 'AC' || label == 'C',
                            isEquals: label == '=',
                            onPressed: () =>
                                debugPrint('Button pressed: $label'),
                          );
                        },
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
