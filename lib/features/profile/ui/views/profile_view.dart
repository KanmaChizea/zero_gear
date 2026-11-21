import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/extensions/string_extensions.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/theme/app_spacing.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/theme/theme_cubit.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/app_back_button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/controls/switch.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/loader.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/modals/modals.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/auth/data/services/auth_service.dart';

import 'package:zero_gear/features/profile/data/services/profile_service.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/user_card.dart';
import '../models/profile_ui_state.dart';
import 'profile_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileViewModel(profileService: context.read<ProfileService>()),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final user = context.select((SessionCubit session) => session.state.user);
    final viewModel = context.read<ProfileViewModel>();
    return BlocListener<ProfileViewModel, ProfileUiState>(
      listener: (context, state) {
        if (state.isLoading) {
          Loader.show();
        } else {
          Loader.hide();
        }
        if (state.errorMessage != null) {
          viewModel.clearError();
          AppToast.error(context, title: state.errorMessage!);
        }
      },
      child: AppScreen(
        header: const AppBackButton(),
        children: [
          UserCard(user: user!),
          AppSpacing.v24,
          ProfileSection(
            title: 'YOUR INFO',
            items: [
              ProfileItem(
                label: 'Profile info',
                onPressed: () => context.pushNamed(AppRoute.profileInfo.name),
              ),
              ProfileItem(
                label: 'Update height and weight',
                onPressed: () =>
                    context.pushNamed(AppRoute.updateHeightWeight.name),
              ),
              ProfileItem(
                label: 'Weight chart',
                onPressed: () => context.pushNamed(AppRoute.weightChart.name),
              ),
            ],
          ),
          AppSpacing.v24,
          ProfileSection(
            title: 'FEATURES',
            items: [
              ProfileItem(
                label: 'Pre-workout stretch',
                subLabel: 'Offer a short warm-up before each workout',
                trailing: AppSwitch(value: user!.profile!.preWorkoutStretch),
                onPressed: () => viewModel.setPreWorkOutStretch(
                  !user.profile!.preWorkoutStretch,
                ),
              ),
              ProfileItem(
                label: 'Post-workout stretch',
                subLabel: 'Offer a cool-down after each workout',
                trailing: AppSwitch(value: user.profile!.postWorkoutStretch),
                onPressed: () => viewModel.setPostWorkOutStretch(
                  !user.profile!.postWorkoutStretch,
                ),
              ),
              ProfileItem(
                label: 'Audio instructions',
                subLabel: 'Read out how-to steps and tips during exercises',
                trailing: AppSwitch(value: user.profile!.audioInstructions),
                onPressed: () => viewModel.setAudioInstructions(
                  !user.profile!.audioInstructions,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          ProfileSection(
            title: 'APP',
            items: [
              ProfileItem(
                label: 'Appearance',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.w,
                  children: [
                    AppText(
                      context.watch<ThemeCubit>().state.name.toTitleCase(),
                      color: context.colors.textSecondary,
                    ),
                    SvgIcon(
                      AppSvgs.chevronRight,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
                onPressed: () => context.pushNamed(AppRoute.appearance.name),
              ),
            ],
          ),
          AppSpacing.v24,
          ProfileSection(
            title: 'ACCOUNT',
            items: [
              ProfileItem(
                label: 'Log out',
                trailing: Container(),
                onPressed: () => AppModals.showConfirmationDialog(
                  context,
                  noLabel: 'Cancel',
                  yesLabel: 'Log out',
                  text:
                      'You will need to sign in again. Your workouts and progress stay saved.',
                  title: 'Log out?',
                  yesOnPress: context.read<AuthService>().signOut,
                ),
              ),
              ProfileItem(
                label: 'Delete account',
                trailing: Container(),
                onPressed: () => context.pushNamed(AppRoute.deleteAccount.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
