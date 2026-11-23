import 'package:flutter/material.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_header.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      header: const AppHeader(
        title: 'Delete account',
        text:
            'This permanently deletes your account and everything in it. It cannot be undone.',
      ),
      footer: Column(
        spacing: 24.h,
        children: [
          Button(label: 'Keep my account', onPressed: context.pop),
          Button(
            label: 'Continue to delete',
            onPressed: () => context.pushNamed(AppRoute.confirmDelete.name),
            variant: ButtonVariant.outlined,
          ),
        ],
      ),
      children: [
        ProfileSection(
          items:
              [
                    'Your profile and name',
                    'Your workout history and calendar',
                    'Your weight history and chart',
                  ]
                  .map(
                    (e) => ProfileItem(
                      label: e,
                      trailing: Container(),
                      onPressed: () {},
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
