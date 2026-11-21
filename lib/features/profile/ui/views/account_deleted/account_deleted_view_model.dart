import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/account_deleted_ui_state.dart';

class AccountDeletedViewModel extends Cubit<AccountDeletedUiState> {
  AccountDeletedViewModel({required this._profileService})
    : super(const AccountDeletedUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
