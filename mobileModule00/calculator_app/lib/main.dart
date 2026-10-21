import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157D5)),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const _maxExpressionLength = 64;
  static const _keys = <_CalculatorKey>[
    _CalculatorKey('AC', _KeyKind.utility),
    _CalculatorKey('C', _KeyKind.utility),
    _CalculatorKey('÷', _KeyKind.operator, '/'),
    _CalculatorKey('×', _KeyKind.operator, '*'),
    _CalculatorKey('7', _KeyKind.number),
    _CalculatorKey('8', _KeyKind.number),
    _CalculatorKey('9', _KeyKind.number),
    _CalculatorKey('−', _KeyKind.operator, '-'),
    _CalculatorKey('4', _KeyKind.number),
    _CalculatorKey('5', _KeyKind.number),
    _CalculatorKey('6', _KeyKind.number),
    _CalculatorKey('+', _KeyKind.operator, '+'),
    _CalculatorKey('1', _KeyKind.number),
    _CalculatorKey('2', _KeyKind.number),
    _CalculatorKey('3', _KeyKind.number),
    _CalculatorKey('=', _KeyKind.equals),
    _CalculatorKey('0', _KeyKind.number),
    _CalculatorKey('.', _KeyKind.number),
    _CalculatorKey('', _KeyKind.empty),
    _CalculatorKey('', _KeyKind.empty),
  ];

  String _expression = '';
  String _result = '0';
  bool _justEvaluated = false;

  bool _isOperator(String character) => '+-*/'.contains(character);

  void _onKeyPressed(_CalculatorKey key) {
    switch (key.kind) {
      case _KeyKind.utility:
        if (key.label == 'AC') {
          _clear();
        } else {
          _backspace();
        }
        break;
      case _KeyKind.equals:
        _evaluate();
        break;
      case _KeyKind.number:
        if (key.label == '.') {
          _inputDecimalPoint();
        } else {
          _inputDigit(key.label);
        }
        break;
      case _KeyKind.operator:
        _inputOperator(key.value!);
        break;
      case _KeyKind.empty:
        return;
    }
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
      _justEvaluated = false;
    });
  }

  void _backspace() {
    if (_expression.isEmpty) return;
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      _result = '0';
      _justEvaluated = false;
    });
  }

  void _inputDigit(String digit) {
    setState(() {
      if (_justEvaluated || _result == 'Error') {
        _expression = '';
        _result = '0';
      }
      if (_expression.length >= _maxExpressionLength) return;
      _expression += digit;
      _justEvaluated = false;
    });
  }

  void _inputDecimalPoint() {
    setState(() {
      if (_justEvaluated || _result == 'Error') {
        _expression = '';
        _result = '0';
      }
      if (_expression.length >= _maxExpressionLength) return;

      final numberStart = _currentNumberStart(_expression);
      final currentNumber = _expression.substring(numberStart);
      if (currentNumber.contains('.')) return;

      if (_expression.isEmpty || _endsWithOperator(_expression)) {
        _expression += '0';
      }
      _expression += '.';
      _justEvaluated = false;
    });
  }

  int _currentNumberStart(String expression) {
    for (var i = expression.length - 1; i >= 0; i--) {
      final character = expression[i];
      if (_isOperator(character)) {
        final isExponentSign =
            (character == '+' || character == '-') &&
            i > 0 &&
            'eE'.contains(expression[i - 1]);
        final isUnarySign =
            character == '-' && (i == 0 || _isOperator(expression[i - 1]));
        if (!isExponentSign && !isUnarySign) return i + 1;
      }
    }
    return 0;
  }

  bool _endsWithOperator(String expression) =>
      expression.isNotEmpty && _isOperator(expression[expression.length - 1]);

  void _inputOperator(String operator) {
    setState(() {
      if (_justEvaluated) {
        if (_result == 'Error') {
          _expression = '';
          _result = '0';
        } else if (_expression.isNotEmpty) {
          _expression = _result;
        }
        _justEvaluated = false;
      }

      if (_expression.isEmpty) {
        if (operator == '-') _expression = '-';
        return;
      }

      if (_endsWithOperator(_expression)) {
        if (operator == '-') {
          if (_expression.endsWith('-')) return;
          _expression += '-';
        } else {
          while (_endsWithOperator(_expression)) {
            _expression = _expression.substring(0, _expression.length - 1);
          }
          if (_expression.isNotEmpty) _expression += operator;
        }
      } else {
        _expression += operator;
      }

      if (_expression.length > _maxExpressionLength) {
        _expression = _expression.substring(0, _maxExpressionLength);
      }
      _result = '0';
    });
  }

  void _evaluate() {
    if (_expression.isEmpty) return;

    setState(() {
      try {
        final value = _ExpressionParser(_expression).parse();
        _result = _formatResult(value);
      } on FormatException {
        _result = 'Error';
      } catch (_) {
        _result = 'Error';
      }
      _justEvaluated = true;
    });
  }

  String _formatResult(double value) {
    if (!value.isFinite) throw const FormatException('Result is not finite');
    if (value == 0) return '0';

    var formatted = value.toStringAsPrecision(12);
    final exponentIndex = formatted.indexOf('e');
    if (exponentIndex >= 0) {
      final mantissa = _trimDecimalZeros(formatted.substring(0, exponentIndex));
      final exponent = formatted.substring(exponentIndex + 1);
      return '${mantissa}e$exponent';
    }
    return _trimDecimalZeros(formatted);
  }

  String _trimDecimalZeros(String value) {
    if (!value.contains('.')) return value;
    return value
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Expression',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              _expression.isEmpty ? '0' : _expression,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Result',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              _result,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: _result == 'Error'
                                        ? colors.error
                                        : colors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: GridView.builder(
                        itemCount: _keys.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                        itemBuilder: (context, index) {
                          final key = _keys[index];
                          if (key.kind == _KeyKind.empty)
                            return const SizedBox.shrink();

                          final background = switch (key.kind) {
                            _KeyKind.equals => colors.primary,
                            _KeyKind.operator ||
                            _KeyKind.utility => colors.primaryContainer,
                            _KeyKind.number ||
                            _KeyKind.empty => colors.surfaceContainerHighest,
                          };
                          final foreground = key.kind == _KeyKind.equals
                              ? colors.onPrimary
                              : colors.onSurface;

                          return Material(
                            color: background,
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => _onKeyPressed(key),
                              child: Center(
                                child: Text(
                                  key.label,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: foreground,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
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

enum _KeyKind { number, operator, utility, equals, empty }

class _CalculatorKey {
  const _CalculatorKey(this.label, this.kind, [this.value]);

  final String label;
  final _KeyKind kind;
  final String? value;
}

class _ExpressionParser {
  _ExpressionParser(this._source);

  final String _source;
  int _position = 0;

  double parse() {
    final value = _parseExpression();
    if (_position != _source.length) {
      throw const FormatException('Unexpected character');
    }
    return _requireFinite(value);
  }

  double _parseExpression() {
    var value = _parseTerm();
    while (_peek == '+' || _peek == '-') {
      final operator = _source[_position++];
      final right = _parseTerm();
      value = operator == '+' ? value + right : value - right;
      _requireFinite(value);
    }
    return value;
  }

  double _parseTerm() {
    var value = _parseUnary();
    while (_peek == '*' || _peek == '/') {
      final operator = _source[_position++];
      final right = _parseUnary();
      if (operator == '/' && right == 0) {
        throw const FormatException('Division by zero');
      }
      value = operator == '*' ? value * right : value / right;
      _requireFinite(value);
    }
    return value;
  }

  double _parseUnary() {
    if (_peek == '+') {
      _position++;
      return _parseUnary();
    }
    if (_peek == '-') {
      _position++;
      return -_parseUnary();
    }
    return _parseNumber();
  }

  double _parseNumber() {
    final start = _position;
    var digitCount = 0;

    while (_isDigit(_peek)) {
      _position++;
      digitCount++;
    }
    if (_peek == '.') {
      _position++;
      while (_isDigit(_peek)) {
        _position++;
        digitCount++;
      }
    }
    if (digitCount == 0) throw const FormatException('Expected a number');

    if (_peek == 'e' || _peek == 'E') {
      _position++;
      if (_peek == '+' || _peek == '-') _position++;
      var exponentDigits = 0;
      while (_isDigit(_peek)) {
        _position++;
        exponentDigits++;
      }
      if (exponentDigits == 0) throw const FormatException('Invalid exponent');
    }

    final value = double.tryParse(_source.substring(start, _position));
    if (value == null) throw const FormatException('Invalid number');
    return _requireFinite(value);
  }

  double _requireFinite(double value) {
    if (!value.isFinite) throw const FormatException('Number is too large');
    return value;
  }

  bool _isDigit(String? character) =>
      character != null &&
      character.codeUnitAt(0) >= 48 &&
      character.codeUnitAt(0) <= 57;

  String? get _peek => _position < _source.length ? _source[_position] : null;
}
