import 'package:equatable/equatable.dart';

enum RatingLevel { none, needsWork, good, great }

class ProgressRating extends Equatable {
  const ProgressRating({
    required this.level,
    required this.value,
    required this.nextTarget,
  });

  const ProgressRating.none()
    : level = RatingLevel.none,
      value = 0,
      nextTarget = null;

  factory ProgressRating.fromWorkoutsPerWeek(double perWeek) {
    if (perWeek >= greatFrom) {
      return ProgressRating(
        level: RatingLevel.great,
        value: perWeek,
        nextTarget: null,
      );
    }
    if (perWeek >= goodFrom) {
      return ProgressRating(
        level: RatingLevel.good,
        value: perWeek,
        nextTarget: greatFrom,
      );
    }
    return ProgressRating(
      level: RatingLevel.needsWork,
      value: perWeek,
      nextTarget: goodFrom,
    );
  }

  static const goodFrom = 3;
  static const greatFrom = 5;

  final RatingLevel level;

  final double value;

  final int? nextTarget;

  @override
  List<Object?> get props => [level, value, nextTarget];
}
