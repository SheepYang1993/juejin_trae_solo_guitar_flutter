import 'package:flutter_midi_pro/flutter_midi_pro.dart';

class MidiUtils {
  static final MidiUtils _instance = MidiUtils._internal();
  factory MidiUtils() => _instance;

  late MidiPro _midiPro;
  bool _isInitialized = false;
  int _sfId = 1; // Soundfont ID

  MidiUtils._internal() {
    _midiPro = MidiPro();
  }

  /// 初始化MIDI引擎
  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        // 加载SoundFont文件
        _sfId = await _midiPro.loadSoundfontAsset(
          assetPath: 'assets/sf2/TimGM6mb.sf2',
        );
        // 设置通道1为吉他音色（吉他音色通常是24）
        await _midiPro.selectInstrument(sfId: _sfId, channel: 1, program: 24);
        _isInitialized = true;
      } catch (e) {
        print('Failed to initialize MIDI: $e');
      }
    }
  }

  /// 播放音符
  /// [note] - MIDI音符值（C4为60）
  /// [duration] - 音符持续时间
  void playNote(int note, {Duration duration = const Duration(seconds: 1)}) {
    if (_isInitialized) {
      // 使用正确的API参数
      _midiPro.playNote(channel: 1, key: note, velocity: 100, sfId: _sfId);

      // 延迟后停止音符
      Future.delayed(duration, () {
        _midiPro.stopNote(channel: 1, key: note, sfId: _sfId);
      });
    }
  }

  /// 停止所有音符
  void stopAllNotes() {
    if (_isInitialized) {
      _midiPro.stopAllNotes(sfId: _sfId);
    }
  }

  /// 设置乐器音色
  /// [program] - 乐器编号（0-127）
  void setInstrument(int program) {
    if (_isInitialized) {
      _midiPro.selectInstrument(sfId: _sfId, channel: 1, program: program);
    }
  }

  /// 获取初始化状态
  bool get isInitialized => _isInitialized;
}
