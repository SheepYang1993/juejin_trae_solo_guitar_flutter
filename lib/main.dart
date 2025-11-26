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
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
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
  // 可选的调列表（包含所有十二个调式，按五度圈顺序排列）
  final List<String> _keys = [
    'C',
    'G',
    'D',
    'A',
    'E',
    'B',
    'F#',
    'Db',
    'Ab',
    'Eb',
    'Bb',
    'F',
  ];

  // 可选的音阶类型列表
  final List<String> _scaleTypes = [
    '大调',
    '大调五声音阶',
    '小调五声音阶',
    '自然小调',
    '和声小调',
    '旋律小调',
    '蓝调',
    '多利亚调式',
    '弗里几亚调式',
    '利底亚调式',
    '混合利底亚调式',
    '洛克里亚调式',
  ];

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
        _currentScale = Scale.pentatonicMinor(rootNote);
        break;
      case '自然小调':
        _currentScale = Scale.naturalMinor(rootNote);
        break;
      case '和声小调':
        _currentScale = Scale.harmonicMinor(rootNote);
        break;
      case '旋律小调':
        _currentScale = Scale.melodicMinor(rootNote);
        break;
      case '蓝调':
        _currentScale = Scale.blues(rootNote);
        break;
      case '多利亚调式':
        _currentScale = Scale.dorian(rootNote);
        break;
      case '弗里几亚调式':
        _currentScale = Scale.phrygian(rootNote);
        break;
      case '利底亚调式':
        _currentScale = Scale.lydian(rootNote);
        break;
      case '混合利底亚调式':
        _currentScale = Scale.mixolydian(rootNote);
        break;
      case '洛克里亚调式':
        _currentScale = Scale.locrian(rootNote);
        break;
      default:
        _currentScale = Scale.major(rootNote);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('吉他指板模拟器'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown.shade50, Colors.brown.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 应用标题
              const Text(
                '吉他指板模拟器',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '6弦12品吉他指板',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
              const SizedBox(height: 30),

              // 调式选择卡片
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '选择调式',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 调式选择网格布局
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 3,
                        children: [
                          // 调选择
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '调',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedKey,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                ),
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
                            ],
                          ),

                          // 音阶类型选择
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '音阶类型',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedScaleType,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                ),
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
                                isExpanded: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 当前音阶信息卡片
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '当前音阶信息',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('音阶名称:'),
                          Text(
                            _currentScale.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('音阶类型:'),
                          Text(
                            _selectedScaleType,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('调:'),
                          Text(
                            _selectedKey,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '包含音符:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentScale.notes.join(', '),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 指板显示卡片
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        '指板显示',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 使用吉他指板组件，显示选中的音阶
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: GuitarFretboardWidget(
                            width: 600,
                            height: 150,
                            scale: _currentScale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 操作按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedKey = 'C';
                        _selectedScaleType = '大调';
                        _updateScale();
                      });
                    },
                    child: const Text('重置为默认设置'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 页脚
              const Text(
                '© 2024 吉他指板模拟器',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
