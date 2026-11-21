import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/profile_service.dart';
import '../../models/weight_chart_ui_state.dart';

class WeightChartViewModel extends Cubit<WeightChartUiState> {
  WeightChartViewModel({required this._profileService})
    : super(const WeightChartUiState());

  // ignore: unused_field
  final ProfileService _profileService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
