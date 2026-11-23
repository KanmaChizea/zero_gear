import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/router/navigation.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_header.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/auth/data/services/auth_service.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';

import '../../models/confirm_delete_ui_state.dart';
import 'confirm_delete_view_model.dart';

class ConfirmDeleteView extends StatelessWidget {
  const ConfirmDeleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ConfirmDeleteViewModel(authService: context.read<AuthService>()),
      child: const _ConfirmDeleteBody(),
    );
  }
}

class _ConfirmDeleteBody extends StatelessWidget {
  const _ConfirmDeleteBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ConfirmDeleteViewModel>();
    return BlocConsumer<ConfirmDeleteViewModel, ConfirmDeleteUiState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          viewModel.clearError();
          AppToast.error(context, title: state.errorMessage!);
        }
      },
      builder: (context, state) {
        return AppScreen(
          header: const AppHeader(
            title: 'Confirm deletion',
            text:
                'You signed up with Google. We will ask you to confirm with Google before deleting your account. This cannot be undone.',
          ),
          footer: Column(
            spacing: 24.h,
            children: [
              Button(
                label: 'Keep my account',
                onPressed: () => context.popUntilNamed(AppRoute.profile.name),
              ),
              Button(
                label: 'Confirm with Google',
                isLoading: state.isLoading,
                variant: ButtonVariant.outlined,
                onPressed: () async {
                  final result = await viewModel.confirm();
                  if (result && context.mounted) {
                    context.goNamed(AppRoute.accountDeleted.name);
                  }
                },
              ),
            ],
          ),
          children: [
            ProfileSection(
              items: [
                ProfileItem(
                  label: 'Google account',
                  trailing: AppText(
                    context.read<SessionCubit>().state.user!.email,
                    color: context.colors.textSecondary,
                    maxLines: 1,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
