import 'package:equatable/equatable.dart';

class PlanDaySummary extends Equatable {
  const PlanDaySummary({
    required this.overallDay,
    required this.name,
    required this.focusMuscles,
  });

  final int overallDay;
  final String name;
  final List<String> focusMuscles;

  @override
  List<Object?> get props => [overallDay, name, focusMuscles];
}
