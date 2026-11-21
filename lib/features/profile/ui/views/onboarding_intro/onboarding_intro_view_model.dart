import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_intro_ui_state.dart';

class OnboardingIntroViewModel extends Cubit<OnboardingIntroUiState> {
  OnboardingIntroViewModel({required this._profileService})
    : super(const OnboardingIntroUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
