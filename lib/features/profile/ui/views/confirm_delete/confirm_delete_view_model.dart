import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/confirm_delete_ui_state.dart';

class ConfirmDeleteViewModel extends Cubit<ConfirmDeleteUiState> {
  ConfirmDeleteViewModel({required this._profileService})
    : super(const ConfirmDeleteUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
