import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/day_detail_ui_state.dart';
import 'day_detail_view_model.dart';

class DayDetailView extends StatelessWidget {
  const DayDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DayDetailViewModel(homeService: context.read<HomeService>()),
      child: const _DayDetailBody(),
    );
  }
}

class _DayDetailBody extends StatelessWidget {
  const _DayDetailBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day Detail')),
      body: BlocBuilder<DayDetailViewModel, DayDetailUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Day Detail'));
        },
      ),
    );
  }
}
