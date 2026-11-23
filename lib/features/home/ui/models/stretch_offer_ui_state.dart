import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/plan_day.dart';
import '../../data/models/plan_exercise.dart';

class StretchOfferUiState extends Equatable {
  const StretchOfferUiState({
    required this.stretches,
    this.isSkipping = false,
    this.errorMessage,
  });

  final AsyncValue<List<PlanExercise>> stretches;
  final bool isSkipping;
  final String? errorMessage;

  factory StretchOfferUiState.initial() =>
      StretchOfferUiState(stretches: AsyncValue.loading());

  int get minutes => PlanDay.stretchMinutes(stretches.data ?? const []);

  @override
  List<Object?> get props => [stretches, isSkipping, errorMessage];

  StretchOfferUiState copyWith({
    AsyncValue<List<PlanExercise>>? stretches,
    bool? isSkipping,
    String? Function()? errorMessage,
  }) {
    return StretchOfferUiState(
      stretches: stretches ?? this.stretches,
      isSkipping: isSkipping ?? this.isSkipping,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
