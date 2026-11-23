import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/formatters.dart';

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

  String get label => switch (level) {
    RatingLevel.none => 'NOT RATED YET',
    RatingLevel.needsWork => 'NEEDS WORK',
    RatingLevel.good => 'GOOD',
    RatingLevel.great => 'GREAT',
  };

  /// For a rating built from this week's workout count.
  String get weekMessage {
    final count = value.toInt();
    final workouts = count == 1 ? 'workout' : 'workouts';
    switch (level) {
      case RatingLevel.none:
        return 'No workouts yet. Do your first one to start your week.';
      case RatingLevel.needsWork when count == 0:
        return 'No workouts yet this week. Start today to get back on track.';
      case RatingLevel.needsWork:
        final more = numberToWords(nextTarget! - count);
        return '$count $workouts so far. $more more gets you to Good.';
      case RatingLevel.good:
        final more = numberToWords(nextTarget! - count);
        return '$count $workouts so far. $more more makes it a great week.';
      case RatingLevel.great:
        final ending = count == greatFrom
            ? 'That is a great week.'
            : 'Keep it up.';
        return '$count workouts this week. $ending';
    }
  }

  /// For a rating built from the average workouts per week.
  String get allTimeMessage {
    final average = value.toStringAsFixed(1);
    switch (level) {
      case RatingLevel.none:
        return 'We rate you after your first full week.';
      case RatingLevel.needsWork:
        return 'You average $average workouts a week. Aim for $goodFrom or more.';
      case RatingLevel.good:
      case RatingLevel.great:
        return 'You average $average workouts a week since you started.';
    }
  }

  @override
  List<Object?> get props => [level, value, nextTarget];
}
