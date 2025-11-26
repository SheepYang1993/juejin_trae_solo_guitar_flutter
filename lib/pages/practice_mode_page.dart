import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../components/guitar_fretboard_painter.dart';
import '../models/scales.dart';

// 练习状态枚举
enum PracticeState {
  showingNote, // 显示当前练习音符
  showingAnswer, // 显示答案
}

class PracticeModePage extends StatefulWidget {
  final Scale scale;
  final String keyName;
  final String scaleType;

  const PracticeModePage({
    super.key,
    required this.scale,
    required this.keyName,
    required this.scaleType,
  });

  @override
  State<PracticeModePage> createState() => _PracticeModePageState();
}

class _PracticeModePageState extends State<PracticeModePage> {
  // 当前练习状态
  PracticeState _currentState = PracticeState.showingNote;

  // 当前练习音符
  Note? _currentNote;

  // 当前练习的音符列表（用于确保同一遍不重复）
  List<Note> _currentPracticeNotes = [];

  // 已练习的音符集合（用于检查是否完成一遍）
  Set<Note> _practicedNotes = {};

  // 练习遍数
  int _practiceRounds = 0;

  // 倒计时秒数
  int _countdown = 5;
  // 用户选择的找音符阶段时长
  int _selectedFindNoteDuration = 5;
  // 用户选择的显示答案阶段时长
  int _selectedShowAnswerDuration = 10;
  // 可选的时长列表（5秒到60秒，步长5秒）
  final List<int> _durationOptions = List.generate(
    12,
    (index) => (index + 1) * 5,
  );

  // 定时器
  Timer? _timer;
  // 倒计时更新定时器
  Timer? _countdownTimer;

  // 初始化练习
  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  // 开始新的一遍练习
  void _startNewRound() {
    setState(() {
      _practiceRounds++;
      _practicedNotes.clear();
      _currentPracticeNotes = List.from(widget.scale.notes)..shuffle();
      // 重置倒计时为用户选择的找音符阶段时长
      _countdown = _selectedFindNoteDuration;
      _showNextNote();
    });
  }

  // 显示下一个练习音符
  void _showNextNote() {
    if (_currentPracticeNotes.isEmpty) {
      // 这遍练习已完成，开始新的一遍
      _startNewRound();
      return;
    }

    setState(() {
      // 从当前练习列表中取出第一个音符
      _currentNote = _currentPracticeNotes.removeAt(0);
      _practicedNotes.add(_currentNote!);
      _currentState = PracticeState.showingNote;
      // 重置倒计时为用户选择的找音符阶段时长
      _countdown = _selectedFindNoteDuration;
    });

    // 启动倒计时更新定时器，每秒更新一次
    _startCountdown();

    // 找音符阶段时长后显示答案
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _selectedFindNoteDuration), () {
      setState(() {
        _currentState = PracticeState.showingAnswer;
        // 重置倒计时为用户选择的显示答案阶段时长
        _countdown = _selectedShowAnswerDuration;
      });

      // 启动倒计时更新定时器，每秒更新一次
      _startCountdown();

      // 显示答案阶段时长后切换到下一个音符
      _timer = Timer(Duration(seconds: _selectedShowAnswerDuration), () {
        _showNextNote();
      });
    });
  }

  // 启动倒计时更新定时器
  void _startCountdown() {
    // 先取消之前的倒计时定时器
    _countdownTimer?.cancel();
    // 每秒更新一次倒计时
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          // 倒计时结束，取消定时器
          _countdownTimer?.cancel();
        }
      });
    });
  }

  // 清理定时器
  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('练习模式'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              // 练习信息卡片
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // 当前练习信息
                        Text(
                          '当前练习: ${widget.keyName} ${widget.scaleType}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '练习遍数: $_practiceRounds',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '剩余音符: ${_currentPracticeNotes.length}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        const Divider(thickness: 1),
                        const SizedBox(height: 20),
                        // 时长设置
                        const Text(
                          '时长设置',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 找音符时长选择
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '找音符时间:',
                              style: TextStyle(fontSize: 18),
                            ),
                            DropdownButton<int>(
                              value: _selectedFindNoteDuration,
                              items: _durationOptions.map((duration) {
                                return DropdownMenuItem<int>(
                                  value: duration,
                                  child: Text('$duration 秒'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFindNoteDuration = value!;
                                  // 如果当前是找音符状态，更新倒计时
                                  if (_currentState ==
                                      PracticeState.showingNote) {
                                    _countdown = value;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // 显示答案时长选择
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '显示答案时间:',
                              style: TextStyle(fontSize: 18),
                            ),
                            DropdownButton<int>(
                              value: _selectedShowAnswerDuration,
                              items: _durationOptions.map((duration) {
                                return DropdownMenuItem<int>(
                                  value: duration,
                                  child: Text('$duration 秒'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedShowAnswerDuration = value!;
                                  // 如果当前是显示答案状态，更新倒计时
                                  if (_currentState ==
                                      PracticeState.showingAnswer) {
                                    _countdown = value;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 当前练习音符卡片
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const Text(
                          '当前练习音符',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentNote?.name ?? '',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentState == PracticeState.showingNote
                              ? '请在指板上找到这个音符...'
                              : '答案已显示',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        // 倒计时显示
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _currentState == PracticeState.showingNote
                                ? '剩余时间: $_countdown 秒'
                                : '下一个音符：$_countdown秒',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 吉他指板卡片
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          '吉他指板',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 使用吉他指板组件，根据练习状态显示不同内容
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: GuitarFretboardWidget(
                              // 找音符时不显示任何音符，只显示答案时显示音阶
                              scale:
                                  _currentState == PracticeState.showingAnswer
                                  ? widget.scale
                                  : null,
                              // 如果是显示答案状态，传递当前练习音符用于高亮
                              highlightNote:
                                  _currentState == PracticeState.showingAnswer
                                  ? _currentNote?.name
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 控制按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showNextNote();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('跳过'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
