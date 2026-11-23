import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/core/utils/result.dart';
import 'package:zero_gear/features/home/data/models/plan_day.dart';
import 'package:zero_gear/features/home/data/services/plan_service.dart';

class DayDetailViewModel extends Cubit<AsyncValue<PlanDay>> {
  DayDetailViewModel({required PlanService planService, required this.day})
    : _planService = planService,
      super(AsyncValue.loading()) {
    initialize();
  }

  final PlanService _planService;
  final int day;

  Future<void> initialize() async {
    emit(AsyncValue.loading());
    final result = await _planService.planDay(day);
    emit(switch (result) {
      Ok(:final value) => AsyncValue.data(value),
      Error(:final error) => AsyncValue.error(error.message),
    });
  }
}
