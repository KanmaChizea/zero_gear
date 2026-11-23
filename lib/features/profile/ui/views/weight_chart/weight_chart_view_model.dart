import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';
import 'package:zero_gear/features/profile/data/models/weight_summary.dart';

import '../../../data/services/profile_service.dart';

class WeightChartViewModel extends Cubit<AsyncValue<WeightSummary>> {
  WeightChartViewModel({required this._profileService})
    : super(AsyncValue.loading()) {
    initialize();
  }

  final ProfileService _profileService;

  Future initialize() async {
    emit(AsyncValue.loading());
    final result = await _profileService.loadWeightSummary();
    switch (result) {
      case Ok(:final value):
        emit(AsyncValue.data(value));
        break;
      case Error(:final error):
        emit(AsyncValue.error(error.message));
    }
  }
}
