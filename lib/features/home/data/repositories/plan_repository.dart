import 'package:zero_gear/core/constants/supabase_names.dart';
import 'package:zero_gear/core/network/network_client.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/exercise.dart';
import '../models/plan_day.dart';
import '../models/plan_day_row.dart';
import '../models/plan_enums.dart';

class PlanRepository {
  PlanRepository(this._client);

  final NetworkClient _client;

  Future<Result<PlanDay>> fetchPlanDay(int day) async {
    final result = await _client.request(
      (db) => db.rpc(Rpc.myPlanDay, params: {'p_day': day}),
    );
    return result.map((json) => PlanDay.fromJson(json as Map<String, Object?>));
  }

  Future<Result<List<PlanDayRow>>> fetchDays(PlanTrack track) async {
    final result = await _client.request(
      (db) => db
          .from(Tables.days)
          .select('stage,day_number,name,focus_muscles')
          .eq('track', track.name)
          .eq('is_active', true)
          .order('stage', ascending: true)
          .order('day_number', ascending: true),
    );
    return result.map(
      (rows) => [for (final row in rows) PlanDayRow.fromJson(row)],
    );
  }

  Future<Result<Exercise?>> fetchExercise(String slug) async {
    final result = await _client.request(
      (db) => db.from(Tables.exercises).select().eq('slug', slug).limit(1),
    );
    return result.map<Exercise?>(
      (rows) => rows.isEmpty ? null : Exercise.fromJson(rows.first),
    );
  }
}
