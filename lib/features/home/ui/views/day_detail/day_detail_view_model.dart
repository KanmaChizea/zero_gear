import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/day_detail_ui_state.dart';

class DayDetailViewModel extends Cubit<DayDetailUiState> {
  DayDetailViewModel({required this._homeService})
    : super(const DayDetailUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
