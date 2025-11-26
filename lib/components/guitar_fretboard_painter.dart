import 'package:flutter/material.dart';
import '../models/guitar_fretboard.dart';
import '../models/scales.dart';

/// 吉他指板绘制组件
class GuitarFretboardPainter extends CustomPainter {
  final GuitarFretboard fretboard;
  final Scale? scale; // 可选的音阶参数

  GuitarFretboardPainter(this.fretboard, {this.scale});

  // 音符颜色映射，用于区分不同音符
  static const Map<String, Color> noteColors = {
    'C': Colors.red,
    'C#': Colors.orange,
    'D': Colors.yellow,
    'Eb': Colors.lime,
    'E': Colors.green,
    'F': Colors.teal,
    'F#': Colors.cyan,
    'G': Colors.blue,
    'Ab': Colors.indigo,
    'A': Colors.purple,
    'Bb': Colors.pink,
    'B': Colors.redAccent,
  };

  @override
  void paint(Canvas canvas, Size size) {
    // 设置绘制样式
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 绘制指板背景
    _drawFretboardBackground(canvas, size);

    // 绘制指板边框
    _drawFretboardBorder(canvas, size, paint);

    // 绘制品丝
    _drawFrets(canvas, size, paint);

    // 绘制品记圆点
    _drawFretMarkers(canvas, size, paint);

    // 绘制弦
    _drawStrings(canvas, size, paint);

    // 绘制音阶音符（如果提供了音阶）
    if (scale != null) {
      _drawScaleNotes(canvas, size);
    }
  }

  // 绘制指板边框
  void _drawFretboardBorder(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  // 绘制品丝
  void _drawFrets(Canvas canvas, Size size, Paint paint) {
    for (int i = 1; i < fretboard.frets.length; i++) {
      final fret = fretboard.frets[i];
      // 计算品丝在画布上的位置
      final x = size.width * fret.position;
      // 绘制品丝线条
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  // 绘制指板背景
  void _drawFretboardBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFF8B4513) // 棕色背景
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  // 绘制品记圆点
  void _drawFretMarkers(Canvas canvas, Size size, Paint paint) {
    // 需要绘制圆点的品位数
    final markerFrets = [3, 5, 7, 9, 12];

    for (int fretNumber in markerFrets) {
      if (fretNumber < fretboard.frets.length) {
        double x;
        final prevFret = fretboard.frets[fretNumber - 1];

        // 对于12品（最后一个品），使用11品到指板末端的中间位置
        if (fretNumber == 12) {
          // 12品是最后一个品，它的右侧是指板末端
          // 计算11品到指板末端的中间位置
          x = size.width * (prevFret.position + (1.0 - prevFret.position) / 2);
        } else {
          // 其他品使用两个品丝之间的中间位置
          final fret = fretboard.frets[fretNumber];
          x =
              size.width *
              (prevFret.position + (fret.position - prevFret.position) / 2);
        }

        // 12品绘制两个圆点
        if (fretNumber == 12) {
          // 计算弦之间的间距
          final stringSpacing = size.height / (fretboard.stringCount - 1);

          // 对于6弦吉他：
          // 琴弦顺序（从下到上）：6弦、5弦、4弦、3弦、2弦、1弦
          // 上方圆点：位于5弦和4弦之间的中间位置
          // 下方圆点：位于2弦和3弦之间的中间位置

          // 5弦位置（从下到上第2根弦）
          final y5thString = stringSpacing;
          // 4弦位置（从下到上第3根弦）
          final y4thString = stringSpacing * 2;
          // 3弦位置（从下到上第4根弦）
          final y3rdString = stringSpacing * 3;
          // 2弦位置（从下到上第5根弦）
          final y2ndString = stringSpacing * 4;

          // 上方圆点：5弦和4弦之间的中间位置
          final y1 = (y5thString + y4thString) / 2;
          // 下方圆点：2弦和3弦之间的中间位置
          final y2 = (y2ndString + y3rdString) / 2;

          _drawMarkerDot(canvas, x, y1, paint);
          _drawMarkerDot(canvas, x, y2, paint);
        } else {
          // 其他品绘制一个圆点（在指板中间）
          final y = size.height / 2;
          _drawMarkerDot(canvas, x, y, paint);
        }
      }
    }
  }

  // 绘制单个品记圆点
  void _drawMarkerDot(Canvas canvas, double x, double y, Paint paint) {
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const dotRadius = 6.0;
    canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
  }

  // 绘制弦
  void _drawStrings(Canvas canvas, Size size, Paint paint) {
    // 计算弦之间的间距
    final stringSpacing = size.height / (fretboard.stringCount - 1);

    // 反转绘制顺序，使得6弦在最下面，1弦在最上面
    // 同时使用数据模型中定义的琴弦粗细
    for (int i = 0; i < fretboard.stringCount; i++) {
      // 计算实际的弦索引：i=0对应6弦，i=5对应1弦
      final stringIndex = fretboard.stringCount - 1 - i;
      final guitarString = fretboard.strings[stringIndex];

      // 计算弦在画布上的位置：6弦在最下面，1弦在最上面
      final y = i * stringSpacing;

      // 使用数据模型中定义的琴弦粗细，转换为合适的像素值
      // 实际弦径范围约为0.012-0.054英寸，转换为像素需要放大
      paint.strokeWidth = guitarString.gauge * 100;

      // 绘制弦线条
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  // 绘制音阶音符
  void _drawScaleNotes(Canvas canvas, Size size) {
    // 获取音阶在指板上的音符位置
    final scaleNotePositions = fretboard.getScaleNotePositions(scale!);

    // 计算弦之间的间距
    final stringSpacing = size.height / (fretboard.stringCount - 1);

    // 分离空弦音符和非空弦音符
    final openStringPositions = scaleNotePositions
        .where((p) => p.fretNumber == 0)
        .toList();
    final frettedPositions = scaleNotePositions
        .where((p) => p.fretNumber > 0)
        .toList();

    // 绘制非空弦音符（在指板上）
    for (final position in frettedPositions) {
      // 计算音符在画布上的位置
      final double x;
      final double y;

      // 计算y坐标（弦的位置）
      // 正确的弦顺序：6弦在最下面，1弦在最上面
      // position.stringNumber=1对应1弦（最细），应该在最上面
      // position.stringNumber=6对应6弦（最粗），应该在最下面
      y = (position.stringNumber - 1) * stringSpacing;

      // 计算x坐标（品的位置）
      if (position.fretNumber == fretboard.fretCount) {
        // 最后一品，位于第11品和指板末端之间的中间位置
        final prevFret = fretboard.frets[position.fretNumber - 1];
        // 计算第11品到指板末端的距离
        final fretWidth = 1.0 - prevFret.position;
        // 计算居中位置
        x = size.width * (prevFret.position + fretWidth / 2);
      } else {
        // 其他品，位于两个品丝之间的中间位置
        final prevFret = fretboard.frets[position.fretNumber - 1];
        final currentFret = fretboard.frets[position.fretNumber];
        final fretWidth = currentFret.position - prevFret.position;
        x = size.width * (prevFret.position + fretWidth / 2);
      }

      // 绘制音符标记
      _drawNoteMarker(canvas, x, y, position.note);
    }

    // 绘制空弦音符（在指板最左侧）
    for (final position in openStringPositions) {
      // 计算音符在画布上的位置
      final double x;
      final double y;

      // 计算y坐标（弦的位置）
      // 正确的弦顺序：6弦在最下面，1弦在最上面
      y = (position.stringNumber - 1) * stringSpacing;

      // 空弦音符绘制在指板最左侧，距离指板左侧有一定间距
      x = 20.0; // 位于指板左侧内部

      // 绘制空弦音符标记
      _drawOpenStringNoteMarker(canvas, x, y, position.note);
    }
  }

  // 绘制空弦音符标记
  void _drawOpenStringNoteMarker(Canvas canvas, double x, double y, Note note) {
    // 获取音符对应的颜色
    final noteColor = noteColors[note.name] ?? Colors.white;

    // 绘制音符圆圈（比指板上的音符稍小）
    final circlePaint = Paint()
      ..color = noteColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    const circleRadius = 10.0;
    canvas.drawCircle(Offset(x, y), circleRadius, circlePaint);

    // 绘制圆圈边框
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(x, y), circleRadius, borderPaint);

    // 绘制音符名称
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(text: note.name, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: 0, maxWidth: circleRadius * 2);

    final textOffset = Offset(
      x - textPainter.width / 2,
      y - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  // 绘制单个音符标记
  void _drawNoteMarker(Canvas canvas, double x, double y, Note note) {
    // 获取音符对应的颜色
    final noteColor = noteColors[note.name] ?? Colors.white;

    // 绘制音符圆圈
    final circlePaint = Paint()
      ..color = noteColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    const circleRadius = 12.0;
    canvas.drawCircle(Offset(x, y), circleRadius, circlePaint);

    // 绘制圆圈边框
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(x, y), circleRadius, borderPaint);

    // 绘制音符名称
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(text: note.name, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: 0, maxWidth: circleRadius * 2);

    final textOffset = Offset(
      x - textPainter.width / 2,
      y - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is GuitarFretboardPainter) {
      return oldDelegate.fretboard != fretboard || oldDelegate.scale != scale;
    }
    return true;
  }
}

/// 吉他指板组件
class GuitarFretboardWidget extends StatelessWidget {
  final Scale? scale; // 可选的音阶参数
  final int stringCount; // 弦数
  final int fretCount; // 品数

  // 默认6弦12品
  const GuitarFretboardWidget({
    super.key,
    this.scale,
    this.stringCount = 6,
    this.fretCount = 12,
  });

  @override
  Widget build(BuildContext context) {
    // 使用LayoutBuilder获取父组件的约束
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 计算合适的宽度：使用父组件宽度的100%，但不超过800像素
        final double calculatedWidth = constraints.maxWidth;
        final double width = calculatedWidth > 800 ? 800 : calculatedWidth;

        // 计算合适的高度：根据宽高比4:1计算，同时考虑弦数
        // 每个弦需要一定的高度，确保音符标记能够清晰显示
        final double ratio = 4.0; // 宽高比
        final double heightBasedOnRatio = width / ratio;
        final double heightBasedOnStrings = stringCount * 25.0; // 每个弦25像素高度
        final double height = heightBasedOnRatio > heightBasedOnStrings
            ? heightBasedOnRatio
            : heightBasedOnStrings;

        // 创建指板数据模型
        final fretboard = GuitarFretboard(
          stringCount: stringCount,
          fretCount: fretCount,
          width: width,
          height: height,
        );

        return SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: GuitarFretboardPainter(fretboard, scale: scale),
          ),
        );
      },
    );
  }
}
