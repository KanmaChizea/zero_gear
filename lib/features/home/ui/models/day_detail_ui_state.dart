import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/plan_day.dart';

class DayDetailUiState extends Equatable {
  const DayDetailUiState({
    required this.plan,
    this.isResuming = false,
    this.startsWithStretch = false,
    this.isStarting = false,
    this.errorMessage,
  });

  final AsyncValue<PlanDay> plan;

  final bool isResuming;
  final bool startsWithStretch;

  final bool isStarting;
  final String? errorMessage;

  factory DayDetailUiState.initial() =>
      DayDetailUiState(plan: AsyncValue.loading());

  @override
  List<Object?> get props => [
    plan,
    isResuming,
    startsWithStretch,
    isStarting,
    errorMessage,
  ];

  DayDetailUiState copyWith({
    AsyncValue<PlanDay>? plan,
    bool? isResuming,
    bool? startsWithStretch,
    bool? isStarting,
    String? Function()? errorMessage,
  }) {
    return DayDetailUiState(
      plan: plan ?? this.plan,
      isResuming: isResuming ?? this.isResuming,
      startsWithStretch: startsWithStretch ?? this.startsWithStretch,
      isStarting: isStarting ?? this.isStarting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
