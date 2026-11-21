import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/workout_record_ui_state.dart';

class WorkoutRecordViewModel extends Cubit<WorkoutRecordUiState> {
  WorkoutRecordViewModel({required this._homeService})
    : super(const WorkoutRecordUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
