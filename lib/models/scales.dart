// 音阶数据模型

/// 音符类
class Note {
  final String
  name; // 音名，如 "C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"
  final int pitch; // 音高，以半音为单位，C4为60
  final int octave; // 八度

  Note({required this.name, required this.pitch, required this.octave});

  // 从音高创建音符
  factory Note.fromPitch(int pitch) {
    final noteNames = [
      'C',
      'C#',
      'D',
      'Eb',
      'E',
      'F',
      'F#',
      'G',
      'Ab',
      'A',
      'Bb',
      'B',
    ];
    final octave = (pitch / 12).floor() - 1;
    final noteName = noteNames[pitch % 12];
    return Note(name: noteName, pitch: pitch, octave: octave);
  }

  // 从音名和八度创建音符
  factory Note.fromName(String name, int octave) {
    final noteNames = [
      'C',
      'C#',
      'D',
      'Eb',
      'E',
      'F',
      'F#',
      'G',
      'Ab',
      'A',
      'Bb',
      'B',
    ];
    final noteIndex = noteNames.indexOf(name);
    if (noteIndex == -1) {
      throw ArgumentError('Invalid note name: $name');
    }
    final pitch = (octave + 1) * 12 + noteIndex;
    return Note(name: name, pitch: pitch, octave: octave);
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

  Scale({
    required this.name,
    required this.type,
    required this.rootNote,
    required this.intervals,
  }) : notes = _generateNotes(rootNote, intervals);

  // 生成音阶包含的音符
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

  @override
  String toString() {
    return '$name: ${notes.join(', ')}';
  }
}
