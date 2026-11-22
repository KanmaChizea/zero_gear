import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/validators.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_header.dart';
import 'package:zero_gear/core/widgets/containers/app_screen.dart';
import 'package:zero_gear/core/widgets/feedback/app_toast.dart';
import 'package:zero_gear/core/widgets/inputs/input_field.dart';

import '../../../data/services/profile_service.dart';
import '../../models/update_height_weight_ui_state.dart';
import 'update_height_weight_view_model.dart';

class UpdateHeightWeightView extends StatelessWidget {
  const UpdateHeightWeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateHeightWeightViewModel(
        profileService: context.read<ProfileService>(),
      ),
      child: const _UpdateHeightWeightBody(),
    );
  }
}

class _UpdateHeightWeightBody extends StatefulWidget {
  const _UpdateHeightWeightBody();

  @override
  State<_UpdateHeightWeightBody> createState() =>
      _UpdateHeightWeightBodyState();
}

class _UpdateHeightWeightBodyState extends State<_UpdateHeightWeightBody> {
  late TextEditingController heightController;
  late TextEditingController weightController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profile = context.read<SessionCubit>().state.user!.profile!;
    heightController = TextEditingController(
      text: profile.heightCm.toInt().toString(),
    );
    weightController = TextEditingController(
      text: profile.weightKg.toInt().toString(),
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<UpdateHeightWeightViewModel>();
    return BlocConsumer<UpdateHeightWeightViewModel, UpdateHeightWeightUiState>(
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
            title: 'Update height and weight',
            text:
                'Your plan stays the same. Every new weight is added to your weight chart.',
          ),
          footer: Button(
            label: 'Save',
            isLoading: state.isLoading,
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final result = await viewModel.submit(
                heightController.text,
                weightController.text,
              );
              if (result && context.mounted) {
                context.pop();
                AppToast.success(
                  context,
                  title: 'Profile updated successfully',
                );
              }
            },
          ),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  InputField(
                    controller: heightController,
                    label: 'Height (cm)',
                    hintText: 'Enter your height in centimeters',
                    validator: Validator.height,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                  AppSpacing.v24,
                  InputField(
                    controller: weightController,
                    label: 'Weight (kg)',
                    hintText: 'Enter your weight in kilograms',
                    validator: Validator.weight,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
