import 'package:zero_gear/core/constants/supabase_names.dart';
import 'package:zero_gear/core/network/network_client.dart';
import 'package:zero_gear/core/shared_features/session/data/models/gender.dart';
import 'package:zero_gear/core/shared_features/session/data/models/profile.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/weight_entry.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final NetworkClient _client;

  Future<Result<Profile?>> fetchProfile() async {
    final result = await _client.request(
      (db) => db.from(Tables.profiles).select().limit(1),
    );
    return result.map<Profile?>(
      (rows) => rows.isEmpty ? null : Profile.fromJson(rows.first),
    );
  }

  Future<Result<Profile>> upsertProfile({
    required String id,
    required Gender gender,
    required double heightCm,
    required double weightKg,
  }) async {
    final result = await _client.request(
      (db) => db
          .from(Tables.profiles)
          .upsert({
            'id': id,
            'gender': gender.name,
            'height_cm': heightCm,
            'weight_kg': weightKg,
          }, onConflict: 'id')
          .select()
          .single(),
    );
    return result.map(Profile.fromJson);
  }

  Future<Result<Profile>> updateProfile(
    String id,
    Map<String, Object?> changes,
  ) async {
    final result = await _client.request(
      (db) => db
          .from(Tables.profiles)
          .update(changes)
          .eq('id', id)
          .select()
          .single(),
    );
    return result.map(Profile.fromJson);
  }

  Future<Result<List<WeightEntry>>> fetchWeightEntries() async {
    final result = await _client.request(
      (db) => db
          .from(Tables.weightEntries)
          .select()
          .order('recorded_at', ascending: true),
    );
    return result.map(
      (rows) => [for (final row in rows) WeightEntry.fromJson(row)],
    );
  }

  Future<Result<WeightEntry>> addWeightEntry({
    required String userId,
    required double weightKg,
  }) async {
    final result = await _client.request(
      (db) => db
          .from(Tables.weightEntries)
          .insert({'user_id': userId, 'weight_kg': weightKg})
          .select()
          .single(),
    );
    return result.map(WeightEntry.fromJson);
  }
}
