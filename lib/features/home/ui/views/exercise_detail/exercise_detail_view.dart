import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_layout.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/extensions/list_extensions.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/app_back_button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/controls/chip.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/exercise.dart';
import 'package:zero_gear/features/home/ui/widgets/exercise/detail_section.dart';
import 'package:zero_gear/features/home/ui/widgets/exercise/exercise_gif.dart';
import 'package:zero_gear/features/home/ui/widgets/workout/wide_workout_layout.dart';

class ExerciseDetailView extends StatelessWidget {
  const ExerciseDetailView({
    super.key,
    required this.exercise,
    required this.repCount,
  });
  final Exercise exercise;
  final String repCount;
  @override
  Widget build(BuildContext context) {
    final wide = AppLayout.isWide(context);
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!wide) ...[
          ExerciseGif(url: exercise.gifUrl, heroTag: exercise.slug),
          AppSpacing.v24,
        ],
        AppText(exercise.name, style: AppTextStyles.display),
        AppSpacing.v4,
        AppText(
          '$repCount ${exercise.restText != null ? ' \u2022 Rest about ${exercise.restText ?? ''}' : ''}',
          color: context.colors.textSecondary,
        ),
        AppSpacing.v24,
        Wrap(
          runSpacing: 8.h,
          spacing: 8.w,
          children: [
            exercise.tempoText,
            exercise.primaryMuscle,
            exercise.kind.name,
          ].removeNull().map(AppChip.new).toList(),
        ),
        AppSpacing.v24,
        DetailSection(
          items: exercise.howTo,
          title: 'How to do it',
          iconBuilder: (index) {
            return Container(
              height: 24.h,
              width: 24.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.bgInverse,
              ),
              child: AppText(
                '${index + 1}',
                style: AppTextStyles.label,
                color: context.colors.textInverse,
              ),
            );
          },
        ),
        AppSpacing.v24,
        DetailSection(
          items: exercise.dos,
          title: 'Do',
          iconBuilder: (_) => const SvgIcon(AppSvgs.check, size: 22),
        ),
        AppSpacing.v24,
        DetailSection(
          items: exercise.donts,
          title: 'Don\'t',
          iconBuilder: (_) => const SvgIcon(AppSvgs.dontCross, size: 22),
        ),
        AppSpacing.v24,
        DetailSection(
          items: exercise.commonMistakes,
          title: 'Common mistakes',
          iconBuilder: (_) => Container(
            height: 6.h,
            width: 6.h,
            margin: AppSpacing.symmetricPadding(vertical: 9, horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.textSecondary,
            ),
          ),
        ),
        AppSpacing.v24,
        if (exercise.whatYouFeel != null)
          Container(
            padding: AppSpacing.symmetricPadding(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: context.colors.bgInverse,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.h,
              children: [
                AppText(
                  'You should feel',
                  style: AppTextStyles.heading,
                  color: context.colors.textInverse,
                ),
                AppText(
                  exercise.whatYouFeel!,
                  color: context.colors.textInverse,
                ),
              ],
            ),
          ),
      ],
    );
    return AppScreen(
      header: const AppBackButton(),
      scrollable: false,
      children: [
        Expanded(
          child: wide
              ? WidePage(
                  image: Align(
                    alignment: Alignment.topCenter,
                    child: ExerciseGif(
                      url: exercise.gifUrl,
                      heroTag: exercise.slug,
                    ),
                  ),
                  details: details,
                )
              : SingleChildScrollView(child: details),
        ),
      ],
    );
  }
}
