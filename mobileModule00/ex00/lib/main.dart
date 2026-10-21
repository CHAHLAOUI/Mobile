import 'package:flutter/material.dart';

void main() {
  runApp(const Ex00App());
}

class Ex00App extends StatelessWidget {
  const Ex00App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise 00 — Basic display',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157D5)),
        useMaterial3: true,
      ),
      home: const BasicDisplayPage(),
    );
  }
}

class BasicDisplayPage extends StatelessWidget {
  const BasicDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth < 480
                      ? constraints.maxWidth
                      : 480,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_iphone_rounded,
                      size: 64,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to my first app!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => debugPrint('Button pressed'),
                      child: const Text('Press me'),
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
