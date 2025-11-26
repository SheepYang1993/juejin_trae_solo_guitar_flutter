import 'package:flutter/material.dart';
import 'components/guitar_fretboard_painter.dart';
import 'models/scales.dart';

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

class GuitarFretboardPage extends StatefulWidget {
  const GuitarFretboardPage({super.key});

  @override
  State<GuitarFretboardPage> createState() => _GuitarFretboardPageState();
}

class _GuitarFretboardPageState extends State<GuitarFretboardPage> {
  // 测试用的音阶列表
  final List<Scale> _scales = [
    Scale.major(Note.fromName('C', 4)),
    Scale.major(Note.fromName('G', 4)),
    Scale.pentatonicMajor(Note.fromName('C', 4)),
    Scale.pentatonicMinor(Note.fromName('A', 4)),
  ];

  // 当前选中的音阶索引
  int _selectedScaleIndex = 0;

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

            // 音阶选择下拉菜单
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<int>(
                value: _selectedScaleIndex,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedScaleIndex = newValue!;
                  });
                },
                items: _scales.map((Scale scale) {
                  return DropdownMenuItem<int>(
                    value: _scales.indexOf(scale),
                    child: Text(scale.name),
                  );
                }).toList(),
              ),
            ),

            // 显示当前选中的音阶信息
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '当前显示: ${_scales[_selectedScaleIndex].name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 使用吉他指板组件，显示选中的音阶
            GuitarFretboardWidget(
              width: 500,
              height: 125,
              scale: _scales[_selectedScaleIndex],
            ),

            // 显示音阶包含的音符
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '音符: ${_scales[_selectedScaleIndex].notes.join(', ')}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
