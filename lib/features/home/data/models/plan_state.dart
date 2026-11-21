import 'package:equatable/equatable.dart';
import 'plan_day_summary.dart';
import 'plan_enums.dart';

class PlanState extends Equatable {
  const PlanState({this.track, this.namedDays = const {}});

  final PlanTrack? track;

  final Map<int, PlanDaySummary> namedDays;

  @override
  List<Object?> get props => [track, namedDays];
}
