import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.scrollable = true,
  });
  final List<Widget> children;
  final Widget? footer;
  final Widget? header;
  final bool scrollable;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            spacing: 24.h,
            children: [
              ?header,
              if (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                )
              else
                ...children,
              ?footer,
            ],
          ),
        ),
      ),
    );
  }
}
