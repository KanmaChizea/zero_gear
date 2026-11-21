import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/content_width.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

enum ToastType {
  success,
  error;

  Color getBgColor(BuildContext context) {
    switch (this) {
      case ToastType.success:
        return context.colors.success;
      case ToastType.error:
        return context.colors.error;
    }
  }

  Color getFgColor(BuildContext context) {
    switch (this) {
      case ToastType.success:
        return context.colors.onSuccess;
      case ToastType.error:
        return context.colors.onError;
    }
  }

  Color getSolidColor(BuildContext context) {
    switch (this) {
      case ToastType.success:
        return context.colors.success;
      case ToastType.error:
        return context.colors.error;
    }
  }
}

class AppToast {
  static OverlayEntry? _entry;

  static void success(
    BuildContext context, {
    required String title,
    String? message,
  }) {
    _show(context, title: title, message: message, type: ToastType.success);
  }

  static void error(
    BuildContext context, {
    required String title,
    String? message,
  }) {
    _show(context, title: title, message: message, type: ToastType.error);
  }

  static void _show(
    BuildContext context, {
    required String title,
    String? message,
    ToastType type = ToastType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismiss();

    final overlay =
        Overlay.maybeOf(context, rootOverlay: true) ??
        Navigator.of(context, rootNavigator: true).overlay;
    if (overlay == null) return;

    final toastKey = GlobalKey<_AnimatedToastState>();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned(
              left: 16.w,
              right: 16.w,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: ContentWidth(
                    child: Material(
                      color: Colors.transparent,
                      child: _AnimatedToast(
                        key: toastKey,
                        onDismissed: () => _remove(entry),
                        builder: (dismiss) => _TopSnackBarContent(
                          title: title,
                          message: message,
                          type: type,
                          onDismiss: dismiss,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(entry);
    _entry = entry;

    Future<void>.delayed(duration, () => toastKey.currentState?.dismiss());
  }

  static void _remove(OverlayEntry entry) {
    if (_entry != entry) return;
    entry.remove();
    _entry = null;
  }

  static void _dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _AnimatedToast extends StatefulWidget {
  final Widget Function(VoidCallback dismiss) builder;
  final VoidCallback onDismissed;

  const _AnimatedToast({
    super.key,
    required this.builder,
    required this.onDismissed,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 1,
  );

  late final Animation<Offset> _offset = Tween(
    begin: Offset.zero,
    end: const Offset(1.2, 0),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

  @override
  void initState() {
    super.initState();
    _controller.reverse();
  }

  void dismiss() {
    if (_controller.status == AnimationStatus.forward ||
        _controller.isCompleted) {
      return;
    }
    _controller.forward().whenComplete(widget.onDismissed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _offset, child: widget.builder(dismiss));
  }
}

class _TopSnackBarContent extends StatelessWidget {
  final String title;
  final String? message;
  final ToastType type;
  final Function()? onDismiss;

  const _TopSnackBarContent({
    required this.title,
    required this.type,
    this.onDismiss,
    this.message,
  });

  static const double _radius = 6;
  static const double _accentWidth = 4;

  @override
  Widget build(BuildContext context) {
    final fgColor = type.getFgColor(context);
    return Semantics(
      liveRegion: true,
      container: true,
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          padding: EdgeInsets.only(left: _accentWidth.w),
          decoration: BoxDecoration(
            color: type.getSolidColor(context),
            borderRadius: BorderRadius.circular(_radius.r),
          ),
          child: Container(
            width: double.infinity,
            padding: AppSpacing.fromLTRB(21, 12, 24, 12),
            decoration: BoxDecoration(
              color: type.getBgColor(context),
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical((_radius - _accentWidth).r, _radius.r),
                right: Radius.circular(_radius.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4.h,
              children: [
                AppText(title, style: AppTextStyles.body, color: fgColor),
                if (message != null)
                  AppText(
                    message!,
                    style: AppTextStyles.caption,
                    color: fgColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
