import 'package:flutter/material.dart';

import '../models/calculator_key.dart';

class CalculatorKeyButton extends StatelessWidget {
  const CalculatorKeyButton({
    required this.calculatorKey,
    required this.onPressed,
    super.key,
  });

  final CalculatorKey calculatorKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = switch (calculatorKey.kind) {
      CalculatorKeyKind.equals => colors.primary,
      CalculatorKeyKind.operation || CalculatorKeyKind.utility =>
        colors.primaryContainer,
      CalculatorKeyKind.number || CalculatorKeyKind.empty =>
        colors.surfaceContainerHighest,
    };
    final foreground = calculatorKey.kind == CalculatorKeyKind.equals
        ? colors.onPrimary
        : colors.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Center(
          child: Text(
            calculatorKey.label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
