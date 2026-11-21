import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class ProfileItem {
  final String label;
  final String? subLabel;
  final Widget? trailing;
  final Function() onPressed;
  ProfileItem({
    required this.label,
    this.trailing,
    this.subLabel,
    required this.onPressed,
  });
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.title, required this.items});
  final String title;
  final List<ProfileItem> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        AppText(
          title,
          style: AppTextStyles.label,
          color: context.colors.textSecondary,
        ),
        Container(
          padding: AppSpacing.symmetricPadding(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(width: 1.5, color: context.colors.borderDefault),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: items[i].onPressed,
                  child: Container(
                    padding: AppSpacing.symmetricPadding(vertical: 16),
                    decoration: BoxDecoration(
                      border: i < items.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: context.colors.borderDefault,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      spacing: 16.w,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                items[i].label,
                                style: AppTextStyles.bodyMedium,
                              ),
                              if (items[i].subLabel != null)
                                AppText(
                                  items[i].subLabel!,
                                  style: AppTextStyles.caption,
                                  color: context.colors.textSecondary,
                                ),
                            ],
                          ),
                        ),
                        items[i].trailing ??
                            SvgIcon(
                              AppSvgs.chevronRight,
                              color: context.colors.textSecondary,
                            ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
