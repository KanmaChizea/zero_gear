import 'package:flutter/material.dart';
import 'package:zero_gear/core/shared_features/session/data/models/user.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 72.h,
            width: 72.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.borderDefault),
              color: context.colors.bgSecondary,
            ),
            child: AppText(
              (user.displayName ?? ' ')[0],
              style: AppTextStyles.title,
            ),
          ),
          AppSpacing.v16,
          AppText(
            user.displayName ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),
          AppSpacing.v4,
          AppText(
            user.email,
            textAlign: TextAlign.center,
            color: context.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
