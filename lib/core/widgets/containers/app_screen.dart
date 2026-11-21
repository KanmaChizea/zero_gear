import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.children,
    this.header,
    this.footer,
  });
  final List<Widget> children;
  final Widget? footer;
  final Widget? header;
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
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      // Lets a Spacer in [children] fill the free space while
                      // the content still scrolls when it is taller.
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: children,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ?footer,
            ],
          ),
        ),
      ),
    );
  }
}
