import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/shared_features/session/data/models/gender.dart';
import 'package:zero_gear/core/shared_features/session/data/models/profile.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/profile_state.dart';
import '../models/weight_summary.dart';
import '../repositories/profile_repository.dart';

class ProfileService extends Cubit<ProfileState> {
  ProfileService(this._repository, this._session)
    : super(const ProfileState());

  final ProfileRepository _repository;
  final SessionCubit _session;

  Profile? get profile => _session.user?.profile;

  Future<Result<Profile?>> loadProfile() async {
    final result = await _repository.fetchProfile();
    if (result case Ok(:final value)) await _store(value);
    return result;
  }

  Future<Result<Profile>> completeOnboarding({
    required String name,
    required Gender gender,
    required double heightCm,
    required double weightKg,
  }) async {
    final userId = _session.user?.id;
    if (userId == null) return const Result.error(_signedOut);

    final saved = await _repository.upsertProfile(
      id: userId,
      name: name,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
    );
    return saved.andThen<Profile>((profile) async {
      await _store(profile);
      final entries = await _repository.fetchWeightEntries();
      return entries.andThen<Profile>((existing) async {
        if (existing.isNotEmpty) return Result.ok(profile);
        final added = await _repository.addWeightEntry(
          userId: userId,
          weightKg: profile.weightKg,
        );
        return added.map((_) => profile);
      });
    });
  }

  Future<Result<Profile>> updateBodyStats({
    required double heightCm,
    required double weightKg,
  }) async {
    final current = _requireProfile();
    return current.andThen<Profile>((profile) async {
      final updated = await _repository.updateProfile(_session.user!.id, {
        'height_cm': heightCm,
        'weight_kg': weightKg,
      });
      return updated.andThen<Profile>((next) async {
        await _store(next);
        if (weightKg == profile.weightKg) return Result.ok(next);
        final added = await _repository.addWeightEntry(
          userId: _session.user!.id,
          weightKg: weightKg,
        );
        return added.map((_) => next);
      });
    });
  }

  Future<Result<Profile>> updateFeatures({
    bool? preWorkoutStretch,
    bool? postWorkoutStretch,
    bool? audioInstructions,
  }) async {
    final current = _requireProfile();
    return current.andThen<Profile>((_) async {
      final updated = await _repository.updateProfile(_session.user!.id, {
        'pre_workout_stretch': ?preWorkoutStretch,
        'post_workout_stretch': ?postWorkoutStretch,
        'audio_instructions': ?audioInstructions,
      });
      if (updated case Ok(:final value)) await _store(value);
      return updated;
    });
  }

  Future<Result<WeightSummary>> loadWeightSummary() async {
    final entries = await _repository.fetchWeightEntries();
    final summary = entries.map(WeightSummary.fromEntries);
    if (summary case Ok(:final value)) emit(ProfileState(weight: value));
    return summary;
  }

  void clear() => emit(const ProfileState());

  Result<Profile> _requireProfile() {
    final profile = this.profile;
    return profile == null
        ? const Result.error(
            AppException('Finish setting up your profile first.'),
          )
        : Result.ok(profile);
  }

  Future<void> _store(Profile? profile) async {
    final user = _session.user;
    if (user != null) await _session.updateUser(user.withProfile(profile));
  }

  static const _signedOut = AppException('Please sign in first.');
}
