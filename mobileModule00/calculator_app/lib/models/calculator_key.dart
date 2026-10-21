enum CalculatorKeyKind { number, operation, utility, equals, empty }

class CalculatorKey {
  const CalculatorKey(this.label, this.kind, [this.value]);

  final String label;
  final CalculatorKeyKind kind;
  final String? value;

  static const all = <CalculatorKey>[
    CalculatorKey('AC', CalculatorKeyKind.utility),
    CalculatorKey('C', CalculatorKeyKind.utility),
    CalculatorKey('\u00F7', CalculatorKeyKind.operation, '/'),
    CalculatorKey('\u00D7', CalculatorKeyKind.operation, '*'),
    CalculatorKey('7', CalculatorKeyKind.number),
    CalculatorKey('8', CalculatorKeyKind.number),
    CalculatorKey('9', CalculatorKeyKind.number),
    CalculatorKey('\u2212', CalculatorKeyKind.operation, '-'),
    CalculatorKey('4', CalculatorKeyKind.number),
    CalculatorKey('5', CalculatorKeyKind.number),
    CalculatorKey('6', CalculatorKeyKind.number),
    CalculatorKey('+', CalculatorKeyKind.operation, '+'),
    CalculatorKey('1', CalculatorKeyKind.number),
    CalculatorKey('2', CalculatorKeyKind.number),
    CalculatorKey('3', CalculatorKeyKind.number),
    CalculatorKey('=', CalculatorKeyKind.equals),
    CalculatorKey('0', CalculatorKeyKind.number),
    CalculatorKey('.', CalculatorKeyKind.number),
    CalculatorKey('', CalculatorKeyKind.empty),
    CalculatorKey('', CalculatorKeyKind.empty),
  ];
}
