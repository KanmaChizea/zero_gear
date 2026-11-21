import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/storage/secure_storage.dart';

import '../models/session_state.dart';
import '../models/user.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(const SessionState.unknown());

  final _storage = SecureStorage();

  User? get user => state.user;

  bool get isSignedIn => state.isSignedIn;

  bool get isResolved => state.isResolved;

  Future<User?> readCachedUser() async {
    final raw = await _storage.read(SecureStorageKey.cachedUser);
    if (raw == null) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      await _storage.delete(SecureStorageKey.cachedUser);
      return null;
    }
  }

  Future<void> start(User user) async {
    await _cacheUser(user);
    emit(SessionState.authenticated(user));
  }

  Future<void> updateUser(User user) async {
    if (state.user?.id != user.id) return;
    await _cacheUser(user);
    emit(SessionState.authenticated(user));
  }

  Future<void> clear({bool keepCached = false}) async {
    if (!keepCached) await _storage.delete(SecureStorageKey.cachedUser);
    if (state.status == SessionStatus.unauthenticated) return;
    emit(const SessionState.unauthenticated());
  }

  Future<void> _cacheUser(User user) =>
      _storage.write(SecureStorageKey.cachedUser, jsonEncode(user.toJson()));
}
