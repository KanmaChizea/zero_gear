import 'package:zero_gear/core/constants/supabase_names.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'package:zero_gear/core/network/network_client.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/workout_record.dart';
import '../models/workout_submission.dart';
import '../models/workout_summary.dart';

class WorkoutRepository {
  WorkoutRepository(this._client);

  final NetworkClient _client;

  static const _pageSize = 1000;

  Future<Result<List<WorkoutSummary>>> fetchWorkouts() async {
    final workouts = <WorkoutSummary>[];
    for (var offset = 0; ; offset += _pageSize) {
      final result = await _client.request(
        (db) => db
            .from(Tables.workouts)
            .select('id,local_date,status,started_at,ended_at')
            .order('local_date', ascending: true)
            .range(offset, offset + _pageSize - 1),
      );
      final page = result.map(
        (rows) => [for (final row in rows) WorkoutSummary.fromJson(row)],
      );
      switch (page) {
        case Error(:final error):
          return Result.error(error);
        case Ok(:final value):
          workouts.addAll(value);
          if (value.length < _pageSize) return Result.ok(workouts);
      }
    }
  }

  Future<Result<WorkoutDetail?>> fetchWorkoutDetail(DateTime date) async {
    final result = await _client.request(
      (db) => db
          .from(Tables.workouts)
          .select(
            'id,local_date,status,started_at,ended_at,'
            'workout_exercises(position,sets_planned,sets_done,'
            'exercises(slug,name,gif_url))',
          )
          .eq('local_date', date.isoDate)
          .order(
            'position',
            ascending: true,
            referencedTable: Tables.workoutExercises,
          )
          .limit(1),
    );
    return result.map<WorkoutDetail?>(
      (rows) => rows.isEmpty ? null : WorkoutDetail.fromJson(rows.first),
    );
  }

  Future<Result<void>> saveWorkout(WorkoutSubmission submission) async {
    final dayIdResult = await _fetchDayId(submission);
    return dayIdResult.andThen<void>((dayId) async {
      final idsResult = await _fetchExerciseIds(
        submission.exercises.map((line) => line.slug).toList(),
      );
      return idsResult.andThen<void>((exerciseIds) async {
        final missing = submission.exercises.where(
          (line) => !exerciseIds.containsKey(line.slug),
        );
        if (missing.isNotEmpty) {
          return const Result.error(
            AppException('An exercise in this workout no longer exists.'),
          );
        }

        final saved = await _client.request(
          (db) => db
              .from(Tables.workouts)
              .upsert({
                'user_id': submission.userId,
                'day_id': dayId,
                'local_date': submission.localDate.isoDate,
                'status': submission.status.name,
                'started_at': submission.startedAt.toUtc().toIso8601String(),
                'ended_at': submission.endedAt.toUtc().toIso8601String(),
              }, onConflict: 'user_id,local_date')
              .select('id')
              .single(),
        );
        return saved.andThen<void>((row) async {
          final workoutId = row['id']! as String;
          final lines = await _client.request(
            (db) => db.from(Tables.workoutExercises).upsert([
              for (final line in submission.exercises)
                {
                  'workout_id': workoutId,
                  'position': line.position,
                  'exercise_id': exerciseIds[line.slug],
                  'sets_planned': line.setsPlanned,
                  'sets_done': line.setsDone,
                },
            ], onConflict: 'workout_id,position'),
          );
          return lines.map<void>((_) {});
        });
      });
    });
  }

  Future<Result<String>> _fetchDayId(WorkoutSubmission submission) async {
    final result = await _client.request(
      (db) => db
          .from(Tables.days)
          .select('id')
          .eq('track', submission.track.name)
          .eq('stage', submission.stage.value)
          .eq('day_number', submission.dayNumber)
          .limit(1),
    );
    return result.andThen<String>((rows) async {
      if (rows.isEmpty) {
        return const Result.error(
          AppException('This plan day no longer exists.'),
        );
      }
      return Result.ok(rows.first['id']! as String);
    });
  }

  Future<Result<Map<String, String>>> _fetchExerciseIds(
    List<String> slugs,
  ) async {
    final result = await _client.request(
      (db) =>
          db.from(Tables.exercises).select('id,slug').inFilter('slug', slugs),
    );
    return result.map(
      (rows) => {
        for (final row in rows) row['slug']! as String: row['id']! as String,
      },
    );
  }
}
