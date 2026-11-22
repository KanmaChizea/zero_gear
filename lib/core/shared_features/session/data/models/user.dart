import 'package:equatable/equatable.dart';

import 'profile.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.profile,
  });

  factory User.fromJson(Map<String, Object?> json) => User(
    id: json['id']! as String,
    email: json['email']! as String,
    displayName: json['displayName'] as String?,
    profile: json['profile'] == null
        ? null
        : Profile.fromJson(json['profile']! as Map<String, Object?>),
  );

  final String id;
  final String email;
  final String? displayName;
  final Profile? profile;

  bool get isOnboarded => profile != null;

  User withProfile(Profile? profile) =>
      User(id: id, email: email, displayName: displayName, profile: profile);

  Map<String, Object?> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'profile': profile?.toJson(),
  };

  @override
  List<Object?> get props => [id, email, displayName, profile];
}
