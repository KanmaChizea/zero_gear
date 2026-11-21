import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/active_stretch_ui_state.dart';

class ActiveStretchViewModel extends Cubit<ActiveStretchUiState> {
  ActiveStretchViewModel({required this._homeService})
    : super(const ActiveStretchUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
