import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({
    required this.expression,
    required this.result,
    super.key,
  });

  final String expression;
  final String result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Expression',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _DisplayValue(value: expression, fontSize: 24),
          const SizedBox(height: 16),
          Text(
            'Result',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          _DisplayValue(value: result, fontSize: 36, bold: true),
        ],
      ),
    );
  }
}

class _DisplayValue extends StatelessWidget {
  const _DisplayValue({
    required this.value,
    required this.fontSize,
    this.bold = false,
  });

  final String value;
  final double fontSize;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
      ),
    );
  }
}
