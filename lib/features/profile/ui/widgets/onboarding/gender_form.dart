import 'package:flutter/material.dart';
import 'package:zero_gear/core/shared_features/session/data/models/gender.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/profile/ui/widgets/onboarding/onboarding_body.dart';

class GenderForm extends StatelessWidget {
  const GenderForm({super.key, required this.selected, required this.onSelect});
  final Gender selected;
  final Function(Gender) onSelect;
  @override
  Widget build(BuildContext context) {
    return OnboardingBody(
      title: 'What\'s your gender?',
      text:
          'Men and women build strength differently, so we shape your weekly plan to fit.',
      info:
          'Your answer decides which muscle groups get more training days, for example more leg and glute work or more arm and chest work.',
      child: Row(
        spacing: 16.w,
        children: Gender.values
            .map(
              (e) => Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(e),
                  child: Container(
                    height: 120.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: selected == e
                          ? context.colors.bgInverse
                          : context.colors.bgPrimary,
                      border: selected == e
                          ? null
                          : Border.all(
                              width: 1.5,
                              color: context.colors.borderDefault,
                            ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgIcon(
                          e.icon,
                          color: selected == e
                              ? context.colors.textInverse
                              : context.colors.textPrimary,
                        ),
                        AppText(
                          e.label,
                          style: AppTextStyles.title,
                          color: selected == e
                              ? context.colors.textInverse
                              : context.colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
