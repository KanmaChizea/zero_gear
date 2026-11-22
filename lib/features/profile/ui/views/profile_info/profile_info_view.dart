import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_header.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';

class ProfileInfoView extends StatelessWidget {
  const ProfileInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((SessionCubit session) => session.state.user)!;
    final profile = user.profile!;
    return AppScreen(
      header: const AppHeader(
        title: 'Profile info',
        text:
            'Your gender shapes how your plan is split, so it is not editable here. Height and weight can be updated.',
      ),
      children: [
        ProfileSection(
          items: [
            ProfileItem(
              label: 'Name',
              trailing: AppText(
                user.displayName ?? '',
                color: context.colors.textSecondary,
              ),
              onPressed: () {},
            ),
            ProfileItem(
              label: 'Gender',
              trailing: AppText(
                profile.gender.label,
                color: context.colors.textSecondary,
              ),
              onPressed: () {},
            ),
            ProfileItem(
              label: 'Height',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.w,
                children: [
                  AppText(
                    '${profile.heightCm.toInt()} cm',
                    color: context.colors.textSecondary,
                  ),
                  SvgIcon(
                    AppSvgs.chevronRight,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
              onPressed: () =>
                  context.pushNamed(AppRoute.updateHeightWeight.name),
            ),
            ProfileItem(
              label: 'Weight',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.w,
                children: [
                  AppText(
                    '${profile.weightKg.toInt()} kg',
                    color: context.colors.textSecondary,
                  ),
                  SvgIcon(
                    AppSvgs.chevronRight,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
              onPressed: () =>
                  context.pushNamed(AppRoute.updateHeightWeight.name),
            ),
          ],
        ),
      ],
    );
  }
}
