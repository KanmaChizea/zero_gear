import 'package:equatable/equatable.dart';

class WeightEntry extends Equatable {
  const WeightEntry({
    required this.id,
    required this.weightKg,
    required this.recordedAt,
  });

  factory WeightEntry.fromJson(Map<String, Object?> json) => WeightEntry(
    id: json['id']! as String,
    weightKg: (json['weight_kg']! as num).toDouble(),
    recordedAt: DateTime.parse(json['recorded_at']! as String).toLocal(),
  );

  final String id;
  final double weightKg;
  final DateTime recordedAt;

  @override
  List<Object?> get props => [id, weightKg, recordedAt];
}
