import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/theme/app_colors.dart';
import 'package:zero_gear/core/theme/app_text_styles.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/containers/app_header.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/error_view.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/profile/data/models/weight_summary.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/weight_change_summary.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/weight_chart.dart';
import 'package:zero_gear/features/profile/ui/widgets/profile/weight_history.dart';

import '../../../data/services/profile_service.dart';
import 'weight_chart_view_model.dart';

class WeightChartView extends StatelessWidget {
  const WeightChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeightChartViewModel(profileService: context.read<ProfileService>()),
      child: const _WeightChartBody(),
    );
  }
}

class _WeightChartBody extends StatelessWidget {
  const _WeightChartBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<WeightChartViewModel>();
    return BlocBuilder<WeightChartViewModel, AsyncValue<WeightSummary>>(
      builder: (context, state) {
        return AppScreen(
          header: const AppHeader(
            title: 'Weight change',
            text: 'Only the days you updated your weight are shown.',
          ),
          children: [
            state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24.h,
                  children: [
                    WeightChangeSummary(data: data),
                    WeightChart(data: data.entries),
                    WeightHistory(data: data.entries),
                  ],
                );
              },
              error: (error) => ErrorView(
                title: 'Error',
                text: error,
                onRetry: viewModel.initialize,
              ),
            ),
          ],
        );
      },
    );
  }
}
