import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/app_colors.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

import 'loader.dart';

class LoaderHost extends StatelessWidget {
  const LoaderHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ValueListenableBuilder<int>(
            valueListenable: Loader.count,
            builder: (context, count, _) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: count > 0
                  ? const _LoaderScreen()
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoaderScreen extends StatelessWidget {
  const _LoaderScreen();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ColoredBox(
      color: isDark
          ? context.colors.bgSecondary.withValues(alpha: 0.72)
          : context.colors.textPrimary.withValues(alpha: 0.4),
      child: const Center(child: LoaderMark()),
    );
  }
}

class LoaderMark extends StatefulWidget {
  const LoaderMark({super.key, this.size = 96});

  final double size;

  @override
  State<LoaderMark> createState() => _LoaderMarkState();
}

class _LoaderMarkState extends State<LoaderMark>
    with SingleTickerProviderStateMixin {
  static const _width = 108.0;
  static const _height = 109.0;
  static const _ringCenter = Alignment(
    48 / _width * 2 - 1,
    61 / _height * 2 - 1,
  );
  static const _kettlebellCenter = Alignment(
    77 / _width * 2 - 1,
    31 / _height * 2 - 1,
  );

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.size.r / _height;
    return SizedBox(
      width: _width * scale,
      height: _height * scale,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            AppSvgs.logoRing,
            colorFilter: ColorFilter.mode(
              context.colors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          RotationTransition(
            turns: _controller,
            alignment: _ringCenter,
            child: RotationTransition(
              turns: ReverseAnimation(_controller),
              alignment: _kettlebellCenter,
              child: SvgPicture.asset(AppSvgs.kettlebell),
            ),
          ),
        ],
      ),
    );
  }
}
