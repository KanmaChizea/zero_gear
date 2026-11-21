import 'package:equatable/equatable.dart';
import 'plan_enums.dart';

class PlanDayRow extends Equatable {
  const PlanDayRow({
    required this.stage,
    required this.dayNumber,
    required this.name,
    required this.focusMuscles,
  });

  factory PlanDayRow.fromJson(Map<String, Object?> json) => PlanDayRow(
    stage: PlanStage.fromJson(json['stage']! as String),
    dayNumber: (json['day_number']! as num).toInt(),
    name: json['name']! as String,
    focusMuscles: [
      for (final muscle in json['focus_muscles']! as List<Object?>)
        muscle! as String,
    ],
  );

  final PlanStage stage;
  final int dayNumber;
  final String name;
  final List<String> focusMuscles;

  int get overallDay => stage.dayOffset + dayNumber;

  @override
  List<Object?> get props => [stage, dayNumber, name, focusMuscles];
}
