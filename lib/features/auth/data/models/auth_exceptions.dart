import 'package:zero_gear/core/utils/app_exception.dart';

final class SignInCancelledException extends AppException {
  const SignInCancelledException() : super('Sign-in was cancelled.');
}

final class AccountMismatchException extends AppException {
  const AccountMismatchException()
    : super('Choose the Google account you are signed in with.');
}
