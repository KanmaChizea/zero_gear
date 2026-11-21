import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/onboarding_complete_ui_state.dart';

class OnboardingCompleteViewModel extends Cubit<OnboardingCompleteUiState> {
  OnboardingCompleteViewModel({required this._profileService})
    : super(const OnboardingCompleteUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
