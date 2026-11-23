import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/plan_day.dart';

class DayDetailUiState extends Equatable {
  const DayDetailUiState({required this.plan, this.isResuming = false});

  final AsyncValue<PlanDay> plan;

  /// True when this day is the workout already in progress, so the main
  /// button resumes it instead of starting it.
  final bool isResuming;

  factory DayDetailUiState.initial() =>
      DayDetailUiState(plan: AsyncValue.loading());

  @override
  List<Object?> get props => [plan, isResuming];

  DayDetailUiState copyWith({AsyncValue<PlanDay>? plan, bool? isResuming}) {
    return DayDetailUiState(
      plan: plan ?? this.plan,
      isResuming: isResuming ?? this.isResuming,
    );
  }
}
