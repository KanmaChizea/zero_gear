import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/stretch_offer_ui_state.dart';
import 'stretch_offer_view_model.dart';

class StretchOfferView extends StatelessWidget {
  const StretchOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StretchOfferViewModel(homeService: context.read<HomeService>()),
      child: const _StretchOfferBody(),
    );
  }
}

class _StretchOfferBody extends StatelessWidget {
  const _StretchOfferBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stretch Offer')),
      body: BlocBuilder<StretchOfferViewModel, StretchOfferUiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Stretch Offer'));
        },
      ),
    );
  }
}
