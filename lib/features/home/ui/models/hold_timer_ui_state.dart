import 'package:equatable/equatable.dart';

enum HoldTimerStage { idle, ready, set, hold, done }

class HoldTimerUiState extends Equatable {
  const HoldTimerUiState({
    this.stage = HoldTimerStage.idle,
    this.secondsLeft = 0,
  });

  final HoldTimerStage stage;
  final int secondsLeft;

  bool get isRunning => stage != HoldTimerStage.idle;

  @override
  List<Object?> get props => [stage, secondsLeft];
}
