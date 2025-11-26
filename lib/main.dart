import 'package:flutter/material.dart';
import 'components/guitar_fretboard_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '吉他指板模拟器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const GuitarFretboardPage(),
    );
  }
}

class GuitarFretboardPage extends StatelessWidget {
  const GuitarFretboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('吉他指板模拟器'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '6弦12品吉他指板',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // 使用吉他指板组件
            const GuitarFretboardWidget(
              width: 500,
              height: 125,
            ),
          ],
        ),
      ),
    );
  }
}
