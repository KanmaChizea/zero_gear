import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/shared_features/session/data/models/user.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/utils/app_logger.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/auth_activity.dart';
import '../models/auth_exceptions.dart';
import '../repositories/auth_repository.dart';
import '../repositories/google_sign_in_repository.dart';

class AuthService extends Cubit<AuthActivity> {
  AuthService(this._repository, this._google, this._session)
    : super(AuthActivity.idle) {
    _signedOut = _repository.signedOut.listen((_) {
      if (!_deletingAccount) _session.clear();
    });
  }

  final AuthRepository _repository;
  final GoogleSignInRepository _google;
  final SessionCubit _session;

  late final StreamSubscription<void> _signedOut;

  // Clearing the session redirects to login, which would skip the
  // "account deleted" screen, so that waits for [completeAccountDeletion].
  bool _deletingAccount = false;

  Future<void> restoreSession() async {
    if (_session.isResolved) return;

    try {
      final current = _repository.currentUser;
      if (current == null) {
        await _session.clear();
        return;
      }
      final cached = await _session.readCachedUser();
      final profile = cached?.id == current.id ? cached?.profile : null;
      if (profile == null) {
        final loaded = await _withProfile(current);
        if (loaded case Ok(:final value)) {
          await _session.start(value);
        } else if (cached?.id == current.id) {
          await _session.start(current.withProfile(null));
        }
      } else {
        await _session.start(current.withProfile(profile));
        unawaited(_refreshProfile());
      }
    } catch (error, stackTrace) {
      AppLogger.log('restoreSession failed: $error\n$stackTrace');
    } finally {
      if (!_session.isResolved) await _session.clear(keepCached: true);
    }
  }

  Future<Result<User>> signInWithGoogle() async {
    emit(AuthActivity.signingIn);
    try {
      final credentials = await _google.signIn();
      final result = await credentials.andThen(_repository.signInWithGoogle);
      switch (result) {
        case Ok(:final value):
          final loaded = await _withProfile(value);
          switch (loaded) {
            case Ok(value: final user):
              await _session.start(user);
            case Error():
              await _repository.signOut();
          }
          return loaded;
        case Error(:final error):
          return Result.error(error);
      }
    } finally {
      emit(AuthActivity.idle);
    }
  }

  Future<void> signOut() async {
    emit(AuthActivity.signingOut);
    try {
      await _repository.signOut();
      await _google.signOut();
      await _session.clear();
    } finally {
      emit(AuthActivity.idle);
    }
  }

  Future<Result<void>> deleteAccount() async {
    emit(AuthActivity.deletingAccount);
    try {
      final credentials = await _google.signIn();
      final reauth = await credentials.andThen(_repository.signInWithGoogle);
      switch (reauth) {
        case Error(:final error):
          return Result.error(error);
        case Ok(:final value):
          if (value.id != _session.user?.id) {
            return const Result.error(AccountMismatchException());
          }
      }

      final deleted = await _repository.deleteAccount();
      switch (deleted) {
        case Error(:final error):
          return Result.error(error);
        case Ok():
          _deletingAccount = true;
          await _google.disconnect();
          await _repository.signOut();
          return const Result.ok(null);
      }
    } finally {
      emit(AuthActivity.idle);
    }
  }

  Future<void> completeAccountDeletion() async {
    _deletingAccount = false;
    await _session.clear();
  }

  Future<Result<User>> _withProfile(User user) async {
    final result = await _repository.fetchProfile();
    return result.map((profile) => user.withProfile(profile));
  }

  Future<void> _refreshProfile() async {
    final user = _session.user;
    if (user == null) return;
    final result = await _repository.fetchProfile();
    if (result case Ok(:final value)) {
      await _session.updateUser(user.withProfile(value));
    }
  }

  @override
  Future<void> close() async {
    await _signedOut.cancel();
    return super.close();
  }
}
