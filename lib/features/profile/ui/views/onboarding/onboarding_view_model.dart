import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_ui_state.dart';

class OnboardingViewModel extends Cubit<OnboardingUiState> {
  OnboardingViewModel({required this._profileService})
    : super(const OnboardingUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
