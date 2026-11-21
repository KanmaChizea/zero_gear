import 'package:flutter/material.dart';
import 'package:zero_gear/core/widgets/inputs/ruler_picker.dart';
import 'package:zero_gear/features/profile/ui/widgets/onboarding/onboarding_body.dart';

class HeightForm extends StatelessWidget {
  const HeightForm({super.key, required this.selected, required this.onSelect});
  final double selected;
  final ValueChanged<double> onSelect;
  @override
  Widget build(BuildContext context) {
    return OnboardingBody(
      title: 'How tall are you?',
      text: 'Slide to set your height. You can change it later.',
      info:
          'Height helps us pick the right exercise variations and rep ranges for your body.',
      child: RulerPicker(
        value: selected,
        onChanged: onSelect,
        min: 100,
        max: 230,
        unit: 'cm',
      ),
    );
  }
}
