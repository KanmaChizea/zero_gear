import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/features/profile/data/models/weight_entry.dart';

class WeightChart extends StatelessWidget {
  const WeightChart({super.key, required this.data});

  final List<WeightEntry> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;
    return Container(
      width: double.infinity,
      height: 236.h,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(width: 1.5, color: colors.borderDefault),
      ),
      child: CustomPaint(
        painter: _WeightChartPainter(
          data: data,
          gridColor: colors.borderDefault,
          lineColor: colors.textPrimary,
          labelStyle: AppTextStyles.caption.copyWith(
            color: colors.textSecondary,
          ),
          latestColor: colors.accentPrimary,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.data,
    required this.gridColor,
    required this.lineColor,
    required this.latestColor,
    required this.labelStyle,
  });

  final List<WeightEntry> data;
  final Color gridColor;
  final Color lineColor;
  final Color latestColor;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.height / 200;
    final gutter = 36 * k;
    final gridTop = 12 * k;
    final gridBottom = 148 * k;
    final inset = 8 * k;

    final weights = data.map((e) => e.weightKg);
    final lo = weights.reduce(math.min).floorToDouble();
    final hiRaw = weights.reduce(math.max).ceilToDouble();
    final step = math.max(1.0, ((hiRaw - lo) / 2).ceilToDouble());
    final hi = lo + 2 * step;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final y = gridTop + (gridBottom - gridTop) / 2 * i;
      canvas.drawLine(Offset(gutter, y), Offset(size.width, y), gridPaint);
      final value = hi - step * i;
      final painter = _text(value.toStringAsFixed(0));
      painter.paint(canvas, Offset(0, y - painter.height / 2));
    }

    final left = gutter + inset;
    final right = size.width - inset;
    final first = data.first.recordedAt.millisecondsSinceEpoch;
    final span = data.last.recordedAt.millisecondsSinceEpoch - first;

    final points = [
      for (final e in data)
        Offset(
          span == 0
              ? right
              : left +
                    (e.recordedAt.millisecondsSinceEpoch - first) /
                        span *
                        (right - left),
          gridBottom -
              (e.weightKg - lo) / (hi - lo) * (gridBottom - gridTop),
        ),
    ];

    if (points.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    final dot = Paint()..color = lineColor;
    final dense = points.length > 1 &&
        (right - left) / (points.length - 1) < 12 * k;
    if (!dense) {
      for (final p in points.take(points.length - 1)) {
        canvas.drawCircle(p, 4 * k, dot);
      }
    }
    canvas.drawCircle(points.last, 6 * k, Paint()..color = latestColor);

    final labelY = 176 * k;
    final start = _text(formatDayMonth(data.first.recordedAt));
    start.paint(
      canvas,
      Offset(
        (points.first.dx - start.width / 2)
            .clamp(gutter, size.width - start.width)
            .toDouble(),
        labelY,
      ),
    );
    if (points.length > 1) {
      final end = _text(formatDayMonth(data.last.recordedAt));
      end.paint(canvas, Offset(size.width - end.width, labelY));
    }
  }

  TextPainter _text(String text) => TextPainter(
    text: TextSpan(text: text, style: labelStyle),
    textDirection: TextDirection.ltr,
  )..layout();

  @override
  bool shouldRepaint(_WeightChartPainter old) =>
      old.data != data ||
      old.gridColor != gridColor ||
      old.lineColor != lineColor ||
      old.latestColor != latestColor ||
      old.labelStyle != labelStyle;
}
