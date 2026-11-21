import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/appearance_ui_state.dart';

class AppearanceViewModel extends Cubit<AppearanceUiState> {
  AppearanceViewModel({required this._profileService})
    : super(const AppearanceUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
