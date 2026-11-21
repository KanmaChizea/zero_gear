import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/profile_info_ui_state.dart';

class ProfileInfoViewModel extends Cubit<ProfileInfoUiState> {
  ProfileInfoViewModel({required this._profileService})
    : super(const ProfileInfoUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
