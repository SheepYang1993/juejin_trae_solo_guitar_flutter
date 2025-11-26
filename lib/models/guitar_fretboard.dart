import 'dart:math';

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
}
