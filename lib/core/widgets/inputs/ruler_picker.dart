import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class RulerPicker extends StatefulWidget {
  const RulerPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.unit,
    this.step = 1,
    this.majorEvery = 5,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final String unit;
  final double step;
  final int majorEvery;

  @override
  State<RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  late final ScrollController _controller;
  late double _value;

  double get _spacing => 10.55.w;
  int get _count => ((widget.max - widget.min) / widget.step).round();

  @override
  void initState() {
    super.initState();
    _value = _clamp(widget.value);
    _controller = ScrollController(initialScrollOffset: _offsetOf(_value));
  }

  @override
  void didUpdateWidget(RulerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _clamp(widget.value);
    if (next == _value) return;
    _value = next;
    if (_controller.hasClients) _controller.jumpTo(_offsetOf(next));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _clamp(double v) => v.clamp(widget.min, widget.max).toDouble();

  double _offsetOf(double v) => (v - widget.min) / widget.step * _spacing;

  double _valueAt(double offset) {
    final index = (offset / _spacing).round().clamp(0, _count);
    return widget.min + index * widget.step;
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final target = _offsetOf(_valueAt(_controller.offset));
      if ((target - _controller.offset).abs() > 0.5) {
        _controller.animateTo(
          target,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    } else if (notification is ScrollUpdateNotification) {
      final next = _valueAt(_controller.offset);
      if (next != _value) {
        HapticFeedback.selectionClick();
        setState(() => _value = next);
        widget.onChanged(next);
      }
    }
    return false;
  }

  String get _label => widget.step % 1 == 0
      ? _value.toStringAsFixed(0)
      : _value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(_label, style: AppTextStyles.numeric),
            AppSpacing.h8,
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: AppText(
                widget.unit,
                style: AppTextStyles.heading,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        AppSpacing.v24,
        SizedBox(
          height: 64.h,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final inset = constraints.maxWidth / 2;
              return Stack(
                alignment: Alignment.center,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: _onScroll,
                    child: SingleChildScrollView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: CustomPaint(
                        size: Size(2 * inset + _count * _spacing, 64.h),
                        painter: _TicksPainter(
                          count: _count,
                          spacing: _spacing,
                          inset: inset,
                          majorEvery: widget.majorEvery,
                          color: colors.borderDefault,
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Container(
                      width: 4.w,
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: colors.textPrimary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TicksPainter extends CustomPainter {
  _TicksPainter({
    required this.count,
    required this.spacing,
    required this.inset,
    required this.majorEvery,
    required this.color,
  });

  final int count;
  final double spacing;
  final double inset;
  final int majorEvery;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final minor = size.height * 22 / 64;
    final major = size.height * 36 / 64;
    for (var i = 0; i <= count; i++) {
      final x = inset + i * spacing;
      final half = (i % majorEvery == 0 ? major : minor) / 2;
      final mid = size.height / 2;
      canvas.drawLine(Offset(x, mid - half), Offset(x, mid + half), paint);
    }
  }

  @override
  bool shouldRepaint(_TicksPainter old) =>
      old.count != count ||
      old.spacing != spacing ||
      old.inset != inset ||
      old.majorEvery != majorEvery ||
      old.color != color;
}
