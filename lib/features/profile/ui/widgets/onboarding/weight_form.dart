import 'package:flutter/material.dart';
import 'package:zero_gear/core/widgets/inputs/ruler_picker.dart';
import 'package:zero_gear/features/profile/ui/widgets/onboarding/onboarding_body.dart';

class WeightForm extends StatelessWidget {
  const WeightForm({super.key, required this.selected, required this.onSelect});
  final double selected;
  final ValueChanged<double> onSelect;
  @override
  Widget build(BuildContext context) {
    return OnboardingBody(
      title: "What's your weight?",
      text: 'Slide to set your weight. You can change it later.',
      info:
          'Your weight sets how hard bodyweight moves feel, so we can start you at the right level.',
      child: RulerPicker(
        value: selected,
        onChanged: onSelect,
        min: 30,
        max: 200,
        unit: 'kg',
      ),
    );
  }
}
