import 'package:zero_gear/core/constants/app_svgs.dart';

enum Gender {
  female('Female', AppSvgs.female),
  male('Male', AppSvgs.male);

  final String label;
  final String icon;

  const Gender(this.label, this.icon);
}
