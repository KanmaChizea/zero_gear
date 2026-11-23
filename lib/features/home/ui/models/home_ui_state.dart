import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/async_value.dart';
import 'package:zero_gear/features/home/data/models/home_summary.dart';

class HomeUiState extends Equatable {
  const HomeUiState({
    required this.summary,
    this.isStarting = false,
    this.isResuming = false,
    this.isGivingUp = false,
    this.errorMessage,
  });

  final AsyncValue<HomeSummary> summary;
  final bool isStarting;
  final bool isResuming;
  final bool isGivingUp;
  final String? errorMessage;

  bool get isBusy => isStarting || isResuming || isGivingUp;

  @override
  List<Object?> get props => [
    summary,
    isStarting,
    isResuming,
    isGivingUp,
    errorMessage,
  ];

  HomeUiState copyWith({
    AsyncValue<HomeSummary>? summary,
    bool? isStarting,
    bool? isResuming,
    bool? isGivingUp,
    String? Function()? errorMessage,
  }) {
    return HomeUiState(
      summary: summary ?? this.summary,
      isStarting: isStarting ?? this.isStarting,
      isResuming: isResuming ?? this.isResuming,
      isGivingUp: isGivingUp ?? this.isGivingUp,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
