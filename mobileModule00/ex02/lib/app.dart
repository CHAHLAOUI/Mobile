import 'package:flutter/material.dart';

import 'pages/calculator_layout_page.dart';

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
