import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/app_update/app_update_cubit.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/content_width.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class AppUpdateHost extends StatelessWidget {
  const AppUpdateHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ContentWidth(
                child: BlocBuilder<AppUpdateCubit, bool>(
                  builder: (context, available) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: available
                        ? const _UpdateBanner()
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpdateBanner extends StatelessWidget {
  const _UpdateBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<AppUpdateCubit>();
    return Material(
      color: colors.bgInverse,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: AppSpacing.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                'A new version is ready',
                style: AppTextStyles.bodyMedium,
                color: colors.textInverse,
              ),
            ),
            Button(
              label: 'Later',
              variant: ButtonVariant.text,
              foregroundColor: colors.textInverse,
              fullWidth: false,
              onPressed: cubit.dismiss,
            ),
            Button(
              label: 'Refresh',
              fullWidth: false,
              onPressed: cubit.refresh,
            ),
          ],
        ),
      ),
    );
  }
}
