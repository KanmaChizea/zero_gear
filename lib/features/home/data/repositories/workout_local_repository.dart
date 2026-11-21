import 'dart:convert';

import 'package:zero_gear/core/storage/local_storage.dart';
import 'package:zero_gear/core/utils/app_logger.dart';

import '../models/active_workout.dart';
import '../models/workout_submission.dart';

class WorkoutLocalRepository {
  WorkoutLocalRepository(this._storage);

  final LocalStorage _storage;

  ActiveWorkout? readActive() {
    final raw = _storage.getString(LocalStorageKey.activeWorkout);
    if (raw == null) return null;
    try {
      return ActiveWorkout.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object catch (error) {
      AppLogger.log('Dropped unreadable active workout: $error');
      return null;
    }
  }

  Future<void> saveActive(ActiveWorkout workout) => _storage.setString(
    LocalStorageKey.activeWorkout,
    jsonEncode(workout.toJson()),
  );

  Future<void> clearActive() => _storage.remove(LocalStorageKey.activeWorkout);

  List<WorkoutSubmission> readPending() {
    final raw = _storage.getString(LocalStorageKey.pendingWorkouts);
    if (raw == null) return const [];
    try {
      return [
        for (final item in jsonDecode(raw) as List<Object?>)
          WorkoutSubmission.fromJson(item! as Map<String, Object?>),
      ];
    } on Object catch (error) {
      AppLogger.log('Dropped unreadable pending workouts: $error');
      return const [];
    }
  }

  Future<void> savePending(List<WorkoutSubmission> submissions) {
    if (submissions.isEmpty) {
      return _storage.remove(LocalStorageKey.pendingWorkouts);
    }
    return _storage.setString(
      LocalStorageKey.pendingWorkouts,
      jsonEncode([for (final item in submissions) item.toJson()]),
    );
  }

  Future<void> clear() async {
    await clearActive();
    await savePending(const []);
  }
}
