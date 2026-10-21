class ExpressionParser {
  ExpressionParser(this._source);

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
      if (exponentDigits == 0) {
        throw const FormatException('Invalid exponent');
      }
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
