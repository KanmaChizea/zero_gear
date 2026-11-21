import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

enum ButtonVariant { filled, outlined, text }

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.enabled = true,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool enabled;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton(context);
    if (fullWidth) return button;
    return Align(widthFactor: 1, heightFactor: 1, child: button);
  }

  Widget _buildButton(BuildContext context) {
    final colors = context.colors;
    final fg = _foreground(colors);
    final bg = _background(colors);

    final child = isLoading
        ? SizedBox.square(
            dimension: 18.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fg,
              semanticsLabel: '$label, loading',
            ),
          )
        : AppText(
            label,
            color: fg,
            style: AppTextStyles.bodyMedium,
            maxLines: 1,
          );

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(fullWidth ? double.infinity : 0, (fullWidth ? 56 : 36).h),
      ),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24.w)),
      backgroundColor: WidgetStatePropertyAll(bg),
      foregroundColor: WidgetStatePropertyAll(fg),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: 0.08)),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStatePropertyAll(_border(colors)),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
    );

    final VoidCallback? onTap = enabled
        ? () {
            if (!isLoading) onPressed?.call();
          }
        : null;

    return switch (variant) {
      ButtonVariant.filled => ElevatedButton(
        onPressed: onTap,
        style: style,
        child: child,
      ),
      ButtonVariant.outlined => OutlinedButton(
        onPressed: onTap,
        style: style,
        child: child,
      ),
      ButtonVariant.text => TextButton(
        onPressed: onTap,
        style: style,
        child: child,
      ),
    };
  }

  Color _background(AppColors colors) {
    if (!enabled) {
      return variant == ButtonVariant.filled
          ? colors.surfaceVariant
          : Colors.transparent;
    }
    return backgroundColor ??
        switch (variant) {
          ButtonVariant.filled => colors.primary,
          ButtonVariant.outlined => colors.background,
          ButtonVariant.text => Colors.transparent,
        };
  }

  Color _foreground(AppColors colors) {
    if (!enabled) return colors.textSecondary;
    return foregroundColor ??
        switch (variant) {
          ButtonVariant.filled => colors.onPrimary,
          ButtonVariant.outlined || ButtonVariant.text => colors.text,
        };
  }

  BorderSide _border(AppColors colors) {
    if (variant != ButtonVariant.outlined) return BorderSide.none;
    return BorderSide(
      color: enabled ? foregroundColor ?? colors.borderStrong : colors.border,
      width: 1.5,
    );
  }
}
