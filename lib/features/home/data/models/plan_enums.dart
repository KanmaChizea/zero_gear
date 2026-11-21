enum PlanStage {
  noEquipment('no_equipment', 0),
  resistanceBand('resistance_band', 48);

  const PlanStage(this.value, this.dayOffset);

  final String value;

  final int dayOffset;

  static PlanStage fromJson(String value) =>
      values.firstWhere((stage) => stage.value == value);
}

enum PlanTrack { male, female }

enum DayPhase { warmup, main, cooldown }

enum ExerciseKind { strength, stretch }

enum Equipment { none, band }
