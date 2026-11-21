import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/update_height_weight_ui_state.dart';

class UpdateHeightWeightViewModel extends Cubit<UpdateHeightWeightUiState> {
  UpdateHeightWeightViewModel({required this._profileService})
    : super(const UpdateHeightWeightUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
