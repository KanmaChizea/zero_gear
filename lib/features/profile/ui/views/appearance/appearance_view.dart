import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/extensions/string_extensions.dart';
import 'package:zero_gear/core/theme/theme_cubit.dart';
import 'package:zero_gear/core/widgets/containers/app_header.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/controls/checkbox.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/profile_section.dart';

class AppearanceView extends StatelessWidget {
  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeCubit>().state;
    return AppScreen(
      header: const AppHeader(
        title: 'Appearance',
        text: 'Choose how Zero Gear looks.',
      ),
      children: [
        ProfileSection(
          items: ThemeMode.values
              .map(
                (e) => ProfileItem(
                  label: e.name.toTitleCase(),
                  trailing: AppCheckbox(value: e == currentTheme),
                  onPressed: () => context.read<ThemeCubit>().setTheme(e),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
