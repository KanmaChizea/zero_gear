import 'package:equatable/equatable.dart';
import 'weight_summary.dart';

class ProfileState extends Equatable {
  const ProfileState({this.weight});

  final WeightSummary? weight;

  @override
  List<Object?> get props => [weight];
}
