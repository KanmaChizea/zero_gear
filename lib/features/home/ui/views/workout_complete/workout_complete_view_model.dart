import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/workout_complete_ui_state.dart';

class WorkoutCompleteViewModel extends Cubit<WorkoutCompleteUiState> {
  WorkoutCompleteViewModel({required this._homeService})
    : super(const WorkoutCompleteUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
