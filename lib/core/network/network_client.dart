import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../utils/app_logger.dart';
import '../utils/result.dart';
import 'network_exception.dart';

class NetworkClient {
  NetworkClient(this._supabase);

  final sb.SupabaseClient _supabase;

  sb.GoTrueClient get auth => _supabase.auth;

  Future<Result<T>> request<T>(
    Future<T> Function(sb.SupabaseClient db) call,
  ) async {
    try {
      return Result.ok(await call(_supabase));
    } on sb.PostgrestException catch (error) {
      AppLogger.log('PostgrestException: ${error.code} ${error.message}');
      final status = int.tryParse(error.code ?? '');
      if (status == 401 || error.code == 'PGRST301') {
        return const Result.error(UnauthorizedException());
      }
      return Result.error(ServerException(status, error.message));
    } on sb.AuthRetryableFetchException catch (error) {
      AppLogger.log('AuthRetryableFetchException: ${error.message}');
      return const Result.error(NetworkException());
    } on sb.AuthException catch (error) {
      AppLogger.log('AuthException: ${error.statusCode} ${error.message}');
      return Result.error(
        ServerException(int.tryParse(error.statusCode ?? ''), error.message),
      );
    } on Exception catch (error) {
      AppLogger.log('Request failed: $error');
      return const Result.error(NetworkException());
    }
  }
}
