import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';

import '../../data/models/plan_exercise.dart';

class ActiveStretchUiState extends Equatable {
  const ActiveStretchUiState({
    required this.stretches,
    this.index = 0,
    this.isFinishing = false,
    this.errorMessage,
  });

  final AsyncValue<List<PlanExercise>> stretches;
  final int index;
  final bool isFinishing;
  final String? errorMessage;

  factory ActiveStretchUiState.initial() =>
      ActiveStretchUiState(stretches: AsyncValue.loading());

  List<PlanExercise> get items => stretches.data ?? const [];

  PlanExercise? get current => index < items.length ? items[index] : null;

  bool get isLast => index >= items.length - 1;

  @override
  List<Object?> get props => [stretches, index, isFinishing, errorMessage];

  ActiveStretchUiState copyWith({
    AsyncValue<List<PlanExercise>>? stretches,
    int? index,
    bool? isFinishing,
    String? Function()? errorMessage,
  }) {
    return ActiveStretchUiState(
      stretches: stretches ?? this.stretches,
      index: index ?? this.index,
      isFinishing: isFinishing ?? this.isFinishing,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
