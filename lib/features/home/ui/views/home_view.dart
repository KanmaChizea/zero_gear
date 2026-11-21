import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/icons/app_logo.dart';
import 'package:zero_gear/core/widgets/icons/svg_icon.dart';

import '../../data/services/home_service.dart';
import '../models/home_ui_state.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeViewModel(homeService: context.read<HomeService>()),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeUiState>(
      builder: (context, state) {
        return AppScreen(
          header: Row(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppLogo(size: 36, style: AppTextStyles.heading),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoute.profile.name),
                child: Container(
                  height: 40.h,
                  width: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.bgTertiary,
                  ),
                  child: SvgIcon(
                    AppSvgs.avatar,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          children: [],
        );
      },
    );
  }
}
