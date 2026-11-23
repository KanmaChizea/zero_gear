import 'package:flutter/widgets.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

/// One page of an active workout or stretch on wide screens: the image stays
/// on the left while the details scroll on the right.
class WidePage extends StatelessWidget {
  const WidePage({super.key, required this.image, required this.details});

  final Widget image;
  final Widget details;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24.w,
      children: [
        Expanded(child: image),
        Expanded(child: SingleChildScrollView(child: details)),
      ],
    );
  }
}

/// Puts [child] under the right column of a [WidePage].
class WideFooter extends StatelessWidget {
  const WideFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24.w,
      children: [
        const Expanded(child: SizedBox.shrink()),
        Expanded(child: child),
      ],
    );
  }
}
