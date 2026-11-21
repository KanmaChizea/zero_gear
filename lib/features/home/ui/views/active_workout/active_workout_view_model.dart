import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/active_workout_ui_state.dart';

class ActiveWorkoutViewModel extends Cubit<ActiveWorkoutUiState> {
  ActiveWorkoutViewModel({required this._homeService})
    : super(const ActiveWorkoutUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
