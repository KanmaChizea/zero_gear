import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zero_gear/core/config/env_config.dart';
import 'package:zero_gear/core/utils/app_exception.dart';
import 'package:zero_gear/core/utils/app_logger.dart';
import 'package:zero_gear/core/utils/result.dart';

import '../models/auth_exceptions.dart';
import '../models/google_credentials.dart';

class GoogleSignInRepository {
  bool _initialized = false;

  // Google puts the hashed nonce in the ID token; Supabase needs the raw value
  // to verify it. Google can only be initialized once, so it lives per process.
  final String _rawNonce = _generateNonce();

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? EnvConfig.googleIosClientId
          : null,
      serverClientId: EnvConfig.googleWebClientId,
      nonce: sha256.convert(utf8.encode(_rawNonce)).toString(),
    );
    _initialized = true;
  }

  Future<Result<GoogleCredentials>> signIn() async {
    try {
      await _ensureInitialized();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return const Result.error(
          AppException('Google did not return an ID token. Please try again.'),
        );
      }
      const scopes = ['email', 'profile'];
      final authorizationClient = account.authorizationClient;
      final authorization =
          await authorizationClient.authorizationForScopes(scopes) ??
          await authorizationClient.authorizeScopes(scopes);
      return Result.ok(
        GoogleCredentials(
          idToken: idToken,
          accessToken: authorization.accessToken,
          nonce: _rawNonce,
        ),
      );
    } on GoogleSignInException catch (error) {
      AppLogger.log('Google sign-in failed: $error');
      return Result.error(switch (error.code) {
        GoogleSignInExceptionCode.canceled => const SignInCancelledException(),
        _ => const AppException('Google sign-in failed. Please try again.'),
      });
    } on Object catch (error) {
      AppLogger.log('Google sign-in failed: $error');
      return const Result.error(
        AppException('Google sign-in failed. Please try again.'),
      );
    }
  }

  Future<void> signOut() => _run((google) => google.signOut());

  Future<void> disconnect() => _run((google) => google.disconnect());

  Future<void> _run(Future<void> Function(GoogleSignIn google) action) async {
    try {
      await _ensureInitialized();
      await action(GoogleSignIn.instance);
    } on Object catch (error) {
      AppLogger.log('Google sign-out failed: $error');
    }
  }
}

String _generateNonce() {
  final random = Random.secure();
  return base64UrlEncode(List.generate(32, (_) => random.nextInt(256)));
}
