import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/delete_account_ui_state.dart';

class DeleteAccountViewModel extends Cubit<DeleteAccountUiState> {
  DeleteAccountViewModel({required this._profileService})
    : super(const DeleteAccountUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
