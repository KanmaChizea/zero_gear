import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.validator,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final String? label;
  final String? hintText;
  final String? errorText;

  /// Runs on `Form.validate()`; return the error message, or null if valid.
  final String? Function(String value)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late bool _hidden = widget.obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => widget.validator?.call(widget.controller?.text ?? ''),
      builder: (field) => _buildField(
        context,
        errorText: widget.errorText ?? field.errorText,
        onChanged: (value) {
          if (field.hasError) field.reset();
          widget.onChanged?.call(value);
        },
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String? errorText,
    required ValueChanged<String> onChanged,
  }) {
    final colors = context.colors;
    final hasError = errorText != null;
    final focused = _focusNode.hasFocus;
    final borderColor = hasError
        ? colors.error
        : focused
        ? colors.borderStrong
        : colors.borderDefault;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            AppText(
              widget.label!,
              style: AppTextStyles.caption,
              color: colors.textSecondary,
            ),
            AppSpacing.v8,
          ],
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? _focusNode.requestFocus : null,
            child: Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: colors.bgPrimary,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: borderColor,
                  width: (focused || hasError ? 2 : 1.5).r,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      obscureText: _hidden,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      inputFormatters: widget.inputFormatters,
                      autofillHints: widget.autofillHints,
                      onChanged: onChanged,
                      onSubmitted: widget.onSubmitted,
                      cursorColor: colors.textPrimary,
                      style: AppTextStyles.body.copyWith(
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: AppTextStyles.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  if (widget.obscureText)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _hidden = !_hidden),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: AppText(
                          _hidden ? 'Show' : 'Hide',
                          style: AppTextStyles.bodyMedium,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (hasError) ...[
            AppSpacing.v4,
            AppText(
              errorText,
              style: AppTextStyles.caption,
              color: colors.error,
            ),
          ],
        ],
      ),
    );
  }
}
