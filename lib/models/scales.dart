// 音阶数据模型

/// 音符类
class Note {
  final String name; // 音名，如 "C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"
  final int pitch; // 音高，以半音为单位，C4为60
  final int octave; // 八度

  // 音符缓存，避免重复创建相同音高的音符
  static final Map<int, Note> _noteCache = {};
  
  // 音名列表，用于快速查找
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B',
  ];

  Note._internal({required this.name, required this.pitch, required this.octave});

  // 从音高创建音符（带缓存）
  factory Note.fromPitch(int pitch) {
    // 检查缓存中是否已有该音高的音符
    if (_noteCache.containsKey(pitch)) {
      return _noteCache[pitch]!;
    }
    
    // 计算八度和音名
    final octave = (pitch / 12).floor() - 1;
    final noteName = noteNames[pitch % 12];
    
    // 创建新音符并缓存
    final note = Note._internal(name: noteName, pitch: pitch, octave: octave);
    _noteCache[pitch] = note;
    return note;
  }

  // 从音名和八度创建音符（带缓存）
  factory Note.fromName(String name, int octave) {
    final noteIndex = noteNames.indexOf(name);
    if (noteIndex == -1) {
      throw ArgumentError('Invalid note name: $name');
    }
    final pitch = (octave + 1) * 12 + noteIndex;
    return Note.fromPitch(pitch);
  }

  // 获取下一个半音
  Note nextHalfStep() {
    return Note.fromPitch(pitch + 1);
  }

  // 获取上一个半音
  Note previousHalfStep() {
    return Note.fromPitch(pitch - 1);
  }

  @override
  String toString() {
    return '$name$octave';
  }
}

/// 音阶类型枚举
enum ScaleType {
  major, // 大调音阶
  pentatonicMajor, // 大调五声音阶
  pentatonicMinor, // 小调五声音阶
}

/// 音阶类
class Scale {
  final String name; // 音阶名称
  final ScaleType type; // 音阶类型
  final Note rootNote; // 根音
  final List<int> intervals; // 音程关系，以半音为单位
  final List<Note> notes; // 音阶包含的音符

  // 音阶缓存，避免重复生成相同的音阶
  static final Map<String, Scale> _scaleCache = {};

  Scale._internal({
    required this.name,
    required this.type,
    required this.rootNote,
    required this.intervals,
    required this.notes,
  });

  factory Scale({
    required String name,
    required ScaleType type,
    required Note rootNote,
    required List<int> intervals,
  }) {
    // 生成缓存键
    final cacheKey = '$type-${rootNote.pitch}';
    
    // 检查缓存中是否已有该音阶
    if (_scaleCache.containsKey(cacheKey)) {
      return _scaleCache[cacheKey]!;
    }
    
    // 生成音阶音符
    final notes = _generateNotes(rootNote, intervals);
    
    // 创建新音阶并缓存
    final scale = Scale._internal(
      name: name,
      type: type,
      rootNote: rootNote,
      intervals: intervals,
      notes: notes,
    );
    _scaleCache[cacheKey] = scale;
    return scale;
  }

  // 生成音阶包含的音符（优化版）
  static List<Note> _generateNotes(Note rootNote, List<int> intervals) {
    final notes = <Note>[];
    var currentPitch = rootNote.pitch;

    // 添加根音
    notes.add(rootNote);

    // 根据音程关系生成其他音符
    for (int i = 1; i < intervals.length; i++) {
      currentPitch += intervals[i];
      notes.add(Note.fromPitch(currentPitch));
    }

    return notes;
  }

  // 生成指定音域内的音阶音符
  static List<Note> _generateNotesInRange(Note rootNote, List<int> intervals, int minPitch, int maxPitch) {
    final notes = <Note>[];
    
    // 生成一个八度的基础音阶
    final baseScale = _generateNotes(rootNote, intervals);
    final baseIntervals = intervals.sublist(1); // 去除第一个0
    
    // 向下扩展到最低音
    var currentPitch = rootNote.pitch;
    while (currentPitch >= minPitch) {
      currentPitch -= 12; // 向下一个八度
      if (currentPitch >= minPitch) {
        notes.insert(0, Note.fromPitch(currentPitch));
        // 添加该八度的其他音符
        var tempPitch = currentPitch;
        for (int interval in baseIntervals) {
          tempPitch += interval;
          if (tempPitch < rootNote.pitch && tempPitch >= minPitch) {
            notes.insert(0, Note.fromPitch(tempPitch));
          }
        }
      }
    }
    
    // 添加原始音阶
    notes.addAll(baseScale);
    
    // 向上扩展到最高音
    currentPitch = rootNote.pitch + 12;
    while (currentPitch <= maxPitch) {
      // 添加该八度的所有音符
      var tempPitch = currentPitch;
      notes.add(Note.fromPitch(tempPitch));
      for (int interval in baseIntervals) {
        tempPitch += interval;
        if (tempPitch <= maxPitch) {
          notes.add(Note.fromPitch(tempPitch));
        }
      }
      currentPitch += 12;
    }
    
    return notes;
  }

  // 获取大调音阶
  factory Scale.major(Note rootNote) {
    // 大调音阶音程关系：全全半全全全半（W-W-H-W-W-W-H）
    // 对应的半音数：0, 2, 4, 5, 7, 9, 11
    final intervals = [0, 2, 2, 1, 2, 2, 2, 1];
    return Scale(
      name: '${rootNote.name} Major',
      type: ScaleType.major,
      rootNote: rootNote,
      intervals: intervals,
    );
  }

  // 获取大调五声音阶
  factory Scale.pentatonicMajor(Note rootNote) {
    // 大调五声音阶音程关系：全全小三全小三（W-W-m3-W-m3）
    // 对应的半音数：0, 2, 4, 7, 9
    final intervals = [0, 2, 2, 3, 2, 3];
    return Scale(
      name: '${rootNote.name} Pentatonic Major',
      type: ScaleType.pentatonicMajor,
      rootNote: rootNote,
      intervals: intervals,
    );
  }

  // 获取小调五声音阶
  factory Scale.pentatonicMinor(Note rootNote) {
    // 小调五声音阶音程关系：小三全全小三全（m3-W-W-m3-W）
    // 对应的半音数：0, 3, 5, 7, 10
    final intervals = [0, 3, 2, 2, 3, 2];
    return Scale(
      name: '${rootNote.name} Pentatonic Minor',
      type: ScaleType.pentatonicMinor,
      rootNote: rootNote,
      intervals: intervals,
    );
  }

  // 获取指定音域内的大调音阶
  factory Scale.majorInRange(Note rootNote, int minPitch, int maxPitch) {
    final intervals = [0, 2, 2, 1, 2, 2, 2, 1];
    final notes = _generateNotesInRange(rootNote, intervals, minPitch, maxPitch);
    return Scale._internal(
      name: '${rootNote.name} Major (Range: ${Note.fromPitch(minPitch)} - ${Note.fromPitch(maxPitch)})',
      type: ScaleType.major,
      rootNote: rootNote,
      intervals: intervals,
      notes: notes,
    );
  }

  // 获取指定音域内的大调五声音阶
  factory Scale.pentatonicMajorInRange(Note rootNote, int minPitch, int maxPitch) {
    final intervals = [0, 2, 2, 3, 2, 3];
    final notes = _generateNotesInRange(rootNote, intervals, minPitch, maxPitch);
    return Scale._internal(
      name: '${rootNote.name} Pentatonic Major (Range: ${Note.fromPitch(minPitch)} - ${Note.fromPitch(maxPitch)})',
      type: ScaleType.pentatonicMajor,
      rootNote: rootNote,
      intervals: intervals,
      notes: notes,
    );
  }

  // 获取指定音域内的小调五声音阶
  factory Scale.pentatonicMinorInRange(Note rootNote, int minPitch, int maxPitch) {
    final intervals = [0, 3, 2, 2, 3, 2];
    final notes = _generateNotesInRange(rootNote, intervals, minPitch, maxPitch);
    return Scale._internal(
      name: '${rootNote.name} Pentatonic Minor (Range: ${Note.fromPitch(minPitch)} - ${Note.fromPitch(maxPitch)})',
      type: ScaleType.pentatonicMinor,
      rootNote: rootNote,
      intervals: intervals,
      notes: notes,
    );
  }

  // 获取多个八度的音阶
  factory Scale.withOctaves(Note rootNote, ScaleType type, int octaveCount) {
    List<int> intervals;
    String typeName;
    
    switch (type) {
      case ScaleType.major:
        intervals = [0, 2, 2, 1, 2, 2, 2, 1];
        typeName = 'Major';
        break;
      case ScaleType.pentatonicMajor:
        intervals = [0, 2, 2, 3, 2, 3];
        typeName = 'Pentatonic Major';
        break;
      case ScaleType.pentatonicMinor:
        intervals = [0, 3, 2, 2, 3, 2];
        typeName = 'Pentatonic Minor';
        break;
    }
    
    // 计算音域
    final minPitch = rootNote.pitch - 12 * ((octaveCount - 1) ~/ 2);
    final maxPitch = rootNote.pitch + 12 * ((octaveCount - 1) ~/ 2) + 12;
    
    final notes = _generateNotesInRange(rootNote, intervals, minPitch, maxPitch);
    
    return Scale._internal(
      name: '${rootNote.name} $typeName ($octaveCount octaves)',
      type: type,
      rootNote: rootNote,
      intervals: intervals,
      notes: notes,
    );
  }

  // 获取音阶中的特定音级（1-7）
  Note getDegree(int degree) {
    if (degree < 1 || degree > 7) {
      throw ArgumentError('Degree must be between 1 and 7');
    }
    return notes[degree - 1];
  }

  @override
  String toString() {
    return '$name: ${notes.join(', ')}';
  }
}
