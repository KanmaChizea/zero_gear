import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/features/auth/data/services/auth_service.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

class AccountDeletedView extends StatelessWidget {
  const AccountDeletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPaddingOf(context),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        AppSpacing.v24,
                        AppSpacing.v32,
                        SvgIcon(
                          AppSvgs.sadBadge,
                          keepOriginalColors: true,
                          currentColor: context.colors.accentOn,
                          size: 72,
                        ),
                        AppSpacing.v24,
                        AppText(
                          'Your account was deleted',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title,
                        ),
                        AppSpacing.v8,
                        AppText(
                          'We are sad to see you go. Your data has been removed, and you can create a new account any time.',
                          color: context.colors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Button(
                  label: 'Back to sign in',
                  onPressed: () async {
                    await context.read<AuthService>().completeAccountDeletion();
                    if (context.mounted) context.goNamed(AppRoute.login.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
