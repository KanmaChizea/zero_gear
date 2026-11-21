import 'package:equatable/equatable.dart';
import 'weight_entry.dart';

class WeightSummary extends Equatable {
  const WeightSummary({
    required this.entries,
    required this.currentKg,
    required this.startKg,
    required this.updateCount,
  });

  factory WeightSummary.fromEntries(List<WeightEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return WeightSummary(
      entries: sorted,
      currentKg: sorted.isEmpty ? null : sorted.last.weightKg,
      startKg: sorted.isEmpty ? null : sorted.first.weightKg,
      updateCount: sorted.isEmpty ? 0 : sorted.length - 1,
    );
  }

  final List<WeightEntry> entries;
  final double? currentKg;
  final double? startKg;

  final int updateCount;

  double? get changeKg =>
      currentKg == null || startKg == null ? null : currentKg! - startKg!;

  @override
  List<Object?> get props => [entries, currentKg, startKg, updateCount];
}
