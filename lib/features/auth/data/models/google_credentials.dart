import 'package:equatable/equatable.dart';

class GoogleCredentials extends Equatable {
  const GoogleCredentials({
    required this.idToken,
    required this.accessToken,
    required this.nonce,
  });

  final String idToken;
  final String accessToken;
  final String nonce;

  @override
  List<Object?> get props => [idToken, accessToken, nonce];
}
