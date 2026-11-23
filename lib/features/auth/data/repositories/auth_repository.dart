import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:zero_gear/core/constants/supabase_names.dart';
import 'package:zero_gear/core/network/network_client.dart';
import 'package:zero_gear/core/shared_features/session/data/models/profile.dart';
import 'package:zero_gear/core/shared_features/session/data/models/user.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/google_credentials.dart';

class AuthRepository {
  AuthRepository(this._client);

  final NetworkClient _client;

  User? get currentUser {
    final user = _client.auth.currentUser;
    return user == null ? null : _toUser(user);
  }

  Stream<void> get signedOut => _client.auth.onAuthStateChange.where(
    (change) => change.event == sb.AuthChangeEvent.signedOut,
  );

  Stream<void> get signedIn => _client.auth.onAuthStateChange.where(
    (change) => change.event == sb.AuthChangeEvent.signedIn,
  );

  Future<Result<Profile?>> fetchProfile() async {
    final result = await _client.request(
      (db) => db.from(Tables.profiles).select().limit(1),
    );
    return result.map<Profile?>(
      (rows) => rows.isEmpty ? null : Profile.fromJson(rows.first),
    );
  }

  Future<Result<User>> signInWithGoogle(GoogleCredentials credentials) async {
    final result = await _client.request(
      (db) => db.auth.signInWithIdToken(
        provider: sb.OAuthProvider.google,
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
        nonce: credentials.nonce,
      ),
    );
    return result.andThen<User>((response) async {
      final user = response.user;
      return user == null
          ? const Result.error(
              AppException('Sign-in failed. Please try again.'),
            )
          : Result.ok(_toUser(user));
    });
  }

  // Leaves the page for Google; the session is picked up when the browser
  // returns to the app.
  Future<Result<void>> signInWithGoogleRedirect() => _client.request<void>(
    (db) => db.auth.signInWithOAuth(
      sb.OAuthProvider.google,
      redirectTo: '${Uri.base.origin}/',
    ),
  );

  Future<Result<void>> signOut() => _client.request<void>(
    (db) => db.auth.signOut(scope: sb.SignOutScope.local),
  );

  Future<Result<void>> deleteAccount() =>
      _client.request<void>((db) => db.rpc(Rpc.deleteMyAccount));

  User _toUser(sb.User user) {
    final metadata = user.userMetadata;
    final name = metadata?['full_name'] ?? metadata?['name'];
    return User(
      id: user.id,
      email: user.email ?? '',
      displayName: name is String && name.isNotEmpty ? name : null,
    );
  }
}
