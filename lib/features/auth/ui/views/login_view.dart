import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/feedback/loader.dart';
import 'package:zero_gear/core/widgets/icons/app_logo.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import '../../data/services/auth_service.dart';
import '../models/login_ui_state.dart';
import 'login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginViewModel(authService: context.read<AuthService>()),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

    return BlocListener<LoginViewModel, LoginUiState>(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(),
            AppSpacing.v24,
            AppText(
              'Train at home. No equipment needed.',
              style: AppTextStyles.display,
            ),
            AppSpacing.v8,
            AppText(
              'Create an account and we will build a weekly plan around you.',
              color: context.colors.textSecondary,
            ),
            const Spacer(),
            Button(label: 'Continue with Google', onPressed: viewModel.submit),
            AppSpacing.v24,
            Center(
              child: AppText(
                'By continuing you agree to the Terms and Privacy Policy.',
                style: AppTextStyles.caption,
                color: context.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
