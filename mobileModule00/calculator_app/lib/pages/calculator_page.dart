import 'package:flutter/material.dart';

import '../models/calculator_key.dart';
import '../services/expression_parser.dart';
import '../utils/result_formatter.dart';
import '../widgets/calculator_screen.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const _maxExpressionLength = 64;

  String _expression = '';
  String _result = '0';
  bool _justEvaluated = false;

  bool _isOperator(String character) => '+-*/'.contains(character);

  void _onKeyPressed(CalculatorKey key) {
    switch (key.kind) {
      case CalculatorKeyKind.utility:
        if (key.label == 'AC') {
          _clear();
        } else {
          _backspace();
        }
        break;
      case CalculatorKeyKind.equals:
        _evaluate();
        break;
      case CalculatorKeyKind.number:
        if (key.label == '.') {
          _inputDecimalPoint();
        } else {
          _inputDigit(key.label);
        }
        break;
      case CalculatorKeyKind.operation:
        _inputOperator(key.value!);
        break;
      case CalculatorKeyKind.empty:
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
        final value = ExpressionParser(_expression).parse();
        _result = formatResult(value);
      } on FormatException {
        _result = 'Error';
      } catch (_) {
        _result = 'Error';
      }
      _justEvaluated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScreen(
      expression: _expression.isEmpty ? '0' : _expression,
      result: _result,
      keys: CalculatorKey.all,
      onKeyPressed: _onKeyPressed,
    );
  }
}
