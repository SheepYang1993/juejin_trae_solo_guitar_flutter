import 'dart:math';
import 'scales.dart';

// 吉他指板数据模型

/// 吉他弦类
class GuitarString {
  final int stringNumber; // 弦号，1-6，1为最细弦
  final String note; // 空弦音
  final double gauge; // 弦径

  GuitarString({
    required this.stringNumber,
    required this.note,
    required this.gauge,
  });
}

/// 吉他品丝类
class Fret {
  final int fretNumber; // 品号，0为空弦
  final double position; // 品丝位置（从琴头到琴桥的距离比例）

  Fret({required this.fretNumber, required this.position});
}

/// 音符位置类，用于表示指板上的音符位置
class NotePosition {
  final int stringNumber; // 弦号
  final int fretNumber; // 品号
  final Note note; // 音符

  NotePosition({
    required this.stringNumber,
    required this.fretNumber,
    required this.note,
  });
}

/// 吉他指板类
class GuitarFretboard {
  final int stringCount; // 弦数
  final int fretCount; // 品数
  final List<GuitarString> strings; // 弦列表
  final List<Fret> frets; // 品丝列表
  final double width; // 指板宽度
  final double height; // 指板高度

  GuitarFretboard({
    this.stringCount = 6,
    this.fretCount = 12,
    required this.width,
    required this.height,
  }) : strings = _createStrings(stringCount),
       frets = _createFrets(fretCount);

  // 创建弦列表
  static List<GuitarString> _createStrings(int count) {
    // 标准吉他调弦：E A D G B E（从6弦到1弦）
    // 6弦：最粗，1弦：最细
    final standardTuning = ['E', 'A', 'D', 'G', 'B', 'E'];
    final standardGauges = [0.054, 0.042, 0.032, 0.024, 0.016, 0.012];

    final strings = <GuitarString>[];
    for (int i = 0; i < count; i++) {
      strings.add(
        GuitarString(
          stringNumber: i + 1,
          note: standardTuning[i],
          gauge: standardGauges[i],
        ),
      );
    }
    return strings;
  }

  // 创建品丝列表
  static List<Fret> _createFrets(int count) {
    final frets = <Fret>[];
    // 空弦位置
    frets.add(Fret(fretNumber: 0, position: 0.0));

    // 计算12品的原始位置值，用于缩放所有品丝位置
    final twelfthFretPosition = 1.0 - 1.0 / (pow(2, 12 / 12.0));

    // 计算品丝位置，使用12平均律，并缩放使得12品位于指板最右端
    for (int i = 1; i <= count; i++) {
      // 品丝位置公式：1 - 1 / (2^(i/12))
      final rawPosition = 1.0 - 1.0 / (pow(2, i / 12.0));
      // 缩放位置，使得12品位于指板最右端（位置为1.0）
      final position = rawPosition / twelfthFretPosition;
      frets.add(Fret(fretNumber: i, position: position));
    }
    return frets;
  }

  // 获取指定弦和品上的音符
  Note getNoteAt(int stringNumber, int fretNumber) {
    if (stringNumber < 1 || stringNumber > stringCount) {
      throw ArgumentError('Invalid string number: $stringNumber');
    }
    if (fretNumber < 0 || fretNumber > fretCount) {
      throw ArgumentError('Invalid fret number: $fretNumber');
    }

    // 获取弦的空弦音
    final guitarString =
        strings[stringCount - stringNumber]; // 注意：strings列表中6弦在索引0，1弦在索引5
    final openNote = Note.fromName(guitarString.note, 4); // 默认使用4八度

    // 计算指定品的音符（每个品增加一个半音）
    return Note.fromPitch(openNote.pitch + fretNumber);
  }

  // 获取指板上所有音符的位置
  List<NotePosition> getAllNotePositions() {
    final notePositions = <NotePosition>[];

    for (int string = 1; string <= stringCount; string++) {
      for (int fret = 0; fret <= fretCount; fret++) {
        final note = getNoteAt(string, fret);
        notePositions.add(
          NotePosition(stringNumber: string, fretNumber: fret, note: note),
        );
      }
    }

    return notePositions;
  }

  // 获取指板上指定音阶的音符位置
  List<NotePosition> getScaleNotePositions(Scale scale) {
    final allNotes = getAllNotePositions();
    final scaleNoteNames = scale.notes.map((note) => note.name).toSet();

    return allNotes
        .where((position) => scaleNoteNames.contains(position.note.name))
        .toList();
  }
}
