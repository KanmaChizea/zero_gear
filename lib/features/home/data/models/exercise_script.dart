import 'plan_exercise.dart';

/// What the audio guide says for an exercise, written to be heard rather
/// than read: short sentences, spoken ordinals and clear section lead-ins.
extension ExerciseScript on PlanExercise {
  /// The full briefing for a workout exercise.
  String get workoutScript {
    final e = exercise;
    final feel = _clean(e.whatYouFeel ?? '');
    return [
      '${e.name}. $_amount.',
      if (e.howTo.isNotEmpty) 'Here is how to do it. ${_steps(e.howTo)}',
      if (feel.isNotEmpty) 'What you should feel. $feel',
      if (e.dos.isNotEmpty) 'Things to do. ${_sentences(e.dos)}',
      if (e.donts.isNotEmpty) 'Things to avoid. ${_sentences(e.donts)}',
      if (e.commonMistakes.isNotEmpty)
        'Common mistakes. ${_sentences(e.commonMistakes)}',
    ].join(' ');
  }

  /// Just the name and how to do a stretch.
  String get stretchScript {
    final e = exercise;
    return ['${e.name}.', if (e.howTo.isNotEmpty) _steps(e.howTo)].join(' ');
  }

  String get _amount {
    final setsText = sets == 1 ? 'One set' : '$sets sets';
    return '$setsText of ${_clean(repsText)}';
  }
}

String _steps(List<String> steps) {
  final cleaned = [
    for (final s in steps)
      if (_clean(s).isNotEmpty) _clean(s),
  ];
  if (cleaned.length == 1) return cleaned.first;
  const middle = ['Next,', 'Then,'];
  return [
    for (var i = 0; i < cleaned.length; i++)
      '${i == 0
          ? 'First,'
          : i == cleaned.length - 1
          ? 'Finally,'
          : middle[(i - 1) % middle.length]} ${cleaned[i]}',
  ].join(' ');
}

String _sentences(List<String> items) => [
  for (final s in items)
    if (_clean(s).isNotEmpty) _clean(s),
].join(' ');

/// Strips list markers and symbols a speech engine would read badly, and
/// makes sure the text ends like a sentence so the voice pauses.
String _clean(String text) {
  var s = text
      .replaceFirst(RegExp(r'^\s*(?:\d+[.)]|[-•*])\s*'), '')
      .replaceAll('&', ' and ')
      .replaceAll('×', ' times ')
      .replaceAll('°', ' degrees ')
      .replaceAll(RegExp(r'\s*[–—]\s*'), ', ')
      .replaceAll(RegExp(r'[*_`#]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (s.isEmpty) return s;
  if (!RegExp(r'[.!?:]$').hasMatch(s)) s = '$s.';
  return s;
}
