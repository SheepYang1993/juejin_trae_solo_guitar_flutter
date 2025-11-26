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
  // 可选的调列表
  final List<String> _keys = ['C', 'G', 'D'];

  // 可选的音阶类型列表
  final List<String> _scaleTypes = ['大调', '大调五声音阶', '小调五声音阶'];

  // 当前选中的调
  String _selectedKey = 'C';

  // 当前选中的音阶类型
  String _selectedScaleType = '大调';

  // 当前生成的音阶
  late Scale _currentScale;

  // 初始化当前音阶
  @override
  void initState() {
    super.initState();
    _updateScale();
  }

  // 更新当前音阶
  void _updateScale() {
    final rootNote = Note.fromName(_selectedKey, 4);

    switch (_selectedScaleType) {
      case '大调':
        _currentScale = Scale.major(rootNote);
        break;
      case '大调五声音阶':
        _currentScale = Scale.pentatonicMajor(rootNote);
        break;
      case '小调五声音阶':
        // 小调五声音阶的根音需要调整，通常小调五声音阶使用关系小调
        // 这里简化处理，直接使用选中的调作为根音
        _currentScale = Scale.pentatonicMinor(rootNote);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('吉他指板模拟器'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '6弦12品吉他指板',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 调式选择区域
              const Text(
                '选择调式',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 调选择下拉菜单
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('调: '),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedKey,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedKey = newValue!;
                        _updateScale();
                      });
                    },
                    items: _keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 30),

                  // 音阶类型选择下拉菜单
                  const Text('音阶类型: '),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedScaleType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedScaleType = newValue!;
                        _updateScale();
                      });
                    },
                    items: _scaleTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 显示当前选中的音阶信息
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '当前显示: ${_currentScale.name}',
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
                scale: _currentScale,
              ),
              const SizedBox(height: 20),

              // 显示音阶包含的音符
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '音符: ${_currentScale.notes.join(', ')}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
