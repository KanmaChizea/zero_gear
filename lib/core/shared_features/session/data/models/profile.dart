import 'package:equatable/equatable.dart';

import 'gender.dart';

class Profile extends Equatable {
  const Profile({
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.preWorkoutStretch,
    required this.postWorkoutStretch,
    required this.audioInstructions,
    required this.startedAt,
  });

  factory Profile.fromJson(Map<String, Object?> json) => Profile(
    gender: Gender.values.byName(json['gender']! as String),
    heightCm: (json['height_cm']! as num).toDouble(),
    weightKg: (json['weight_kg']! as num).toDouble(),
    preWorkoutStretch: json['pre_workout_stretch']! as bool,
    postWorkoutStretch: json['post_workout_stretch']! as bool,
    audioInstructions: json['audio_instructions']! as bool,
    startedAt: DateTime.parse(json['started_at']! as String).toLocal(),
  );

  final Gender gender;
  final double heightCm;
  final double weightKg;
  final bool preWorkoutStretch;
  final bool postWorkoutStretch;
  final bool audioInstructions;
  final DateTime startedAt;

  Map<String, Object?> toJson() => {
    'gender': gender.name,
    'height_cm': heightCm,
    'weight_kg': weightKg,
    'pre_workout_stretch': preWorkoutStretch,
    'post_workout_stretch': postWorkoutStretch,
    'audio_instructions': audioInstructions,
    'started_at': startedAt.toUtc().toIso8601String(),
  };

  @override
  List<Object?> get props => [
    gender,
    heightCm,
    weightKg,
    preWorkoutStretch,
    postWorkoutStretch,
    audioInstructions,
    startedAt,
  ];
}
