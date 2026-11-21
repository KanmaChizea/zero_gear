import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: AppSpacing.screenPadding, child: child),
      ),
    );
  }
}
