import 'package:flutter/material.dart';
import '../models/guitar_fretboard.dart';

/// 吉他指板绘制组件
class GuitarFretboardPainter extends CustomPainter {
  final GuitarFretboard fretboard;

  GuitarFretboardPainter(this.fretboard);

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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// 吉他指板组件
class GuitarFretboardWidget extends StatelessWidget {
  final double width;
  final double height;

  // 优化长宽比例，默认4:1的比例（符合实际吉他指板比例）
  const GuitarFretboardWidget({super.key, this.width = 400, this.height = 100});

  @override
  Widget build(BuildContext context) {
    // 创建指板数据模型
    final fretboard = GuitarFretboard(
      stringCount: 6,
      fretCount: 12,
      width: width,
      height: height,
    );

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: GuitarFretboardPainter(fretboard)),
    );
  }
}
