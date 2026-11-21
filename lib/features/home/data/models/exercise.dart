import 'package:equatable/equatable.dart';
import 'package:zero_gear/core/utils/json_utils.dart';
import 'plan_enums.dart';

class Exercise extends Equatable {
  const Exercise({
    required this.slug,
    required this.name,
    required this.kind,
    required this.equipment,
    required this.primaryMuscle,
    required this.gifUrl,
    required this.restText,
    required this.tempoText,
    required this.howTo,
    required this.commonMistakes,
    required this.dos,
    required this.donts,
    required this.whatYouFeel,
  });

  factory Exercise.fromJson(Map<String, Object?> json) => Exercise(
    slug: json['slug']! as String,
    name: json['name']! as String,
    kind: ExerciseKind.values.byName(json['kind']! as String),
    equipment: Equipment.values.byName(json['equipment']! as String),
    primaryMuscle: json['primary_muscle']! as String,
    gifUrl: json['gif_url'] as String?,
    restText: json['rest_text'] as String?,
    tempoText: json['tempo_text'] as String?,
    howTo: jsonStrings(json['how_to']),
    commonMistakes: jsonStrings(json['common_mistakes']),
    dos: jsonStrings(json['dos']),
    donts: jsonStrings(json['donts']),
    whatYouFeel: json['what_you_feel'] as String?,
  );

  final String slug;
  final String name;
  final ExerciseKind kind;
  final Equipment equipment;
  final String primaryMuscle;

  final String? gifUrl;
  final String? restText;
  final String? tempoText;
  final List<String> howTo;
  final List<String> commonMistakes;
  final List<String> dos;
  final List<String> donts;
  final String? whatYouFeel;

  Map<String, Object?> toJson() => {
    'slug': slug,
    'name': name,
    'kind': kind.name,
    'equipment': equipment.name,
    'primary_muscle': primaryMuscle,
    'gif_url': gifUrl,
    'rest_text': restText,
    'tempo_text': tempoText,
    'how_to': howTo,
    'common_mistakes': commonMistakes,
    'dos': dos,
    'donts': donts,
    'what_you_feel': whatYouFeel,
  };

  @override
  List<Object?> get props => [
    slug,
    name,
    kind,
    equipment,
    primaryMuscle,
    gifUrl,
    restText,
    tempoText,
    howTo,
    commonMistakes,
    dos,
    donts,
    whatYouFeel,
  ];
}
