import 'package:equatable/equatable.dart';

class GoogleCredentials extends Equatable {
  const GoogleCredentials({required this.idToken, required this.accessToken});

  final String idToken;
  final String accessToken;

  @override
  List<Object?> get props => [idToken, accessToken];
}
