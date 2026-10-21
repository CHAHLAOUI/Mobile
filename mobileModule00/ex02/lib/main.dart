import 'package:flutter/material.dart';

void main() {
  runApp(const Ex02App());
}

class Ex02App extends StatelessWidget {
  const Ex02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157D5)),
        useMaterial3: true,
      ),
      home: const CalculatorLayoutPage(),
    );
  }
}

class CalculatorLayoutPage extends StatelessWidget {
  const CalculatorLayoutPage({super.key});

  static const _buttons = <String>[
    'AC',
    'C',
    '÷',
    '×',
    '7',
    '8',
    '9',
    '−',
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
      const {'÷', '×', '−', '+', '='}.contains(label);

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
                maxWidth: constraints.maxWidth < 640
                    ? constraints.maxWidth
                    : 640,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 22,
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
                          const Text(
                            '0',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Result',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '0',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
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

                          final isUtility = label == 'AC' || label == 'C';
                          final background = label == '='
                              ? colors.primary
                              : _isOperator(label) || isUtility
                              ? colors.primaryContainer
                              : colors.surfaceContainerHighest;
                          final foreground = label == '='
                              ? colors.onPrimary
                              : colors.onSurface;

                          return Material(
                            color: background,
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => debugPrint('Button pressed: $label'),
                              child: Center(
                                child: Text(
                                  label,
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
