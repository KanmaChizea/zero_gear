import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/exercise_detail_ui_state.dart';

class ExerciseDetailViewModel extends Cubit<ExerciseDetailUiState> {
  ExerciseDetailViewModel({required this._homeService})
    : super(const ExerciseDetailUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
