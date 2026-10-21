import 'package:flutter/material.dart';

class CalculatorKeyButton extends StatelessWidget {
  const CalculatorKeyButton({
    required this.label,
    required this.onPressed,
    this.isOperator = false,
    this.isUtility = false,
    this.isEquals = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isOperator;
  final bool isUtility;
  final bool isEquals;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = isEquals
        ? colors.primary
        : isOperator || isUtility
        ? colors.primaryContainer
        : colors.surfaceContainerHighest;
    final foreground = isEquals ? colors.onPrimary : colors.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Center(
          child: Text(
            label,
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
