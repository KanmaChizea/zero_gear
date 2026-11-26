import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/audio/audio_guide.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/buttons/button.dart';
import 'package:zero_gear/core/widgets/containers/app_card.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';

import '../../models/hold_timer_ui_state.dart';
import 'hold_timer_view_model.dart';

class HoldTimer extends StatelessWidget {
  const HoldTimer({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HoldTimerViewModel(
        audio: context.read<AudioGuide>(),
        seconds: seconds,
      ),
      child: const _HoldTimerBody(),
    );
  }
}

class _HoldTimerBody extends StatelessWidget {
  const _HoldTimerBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HoldTimerViewModel>();
    return BlocBuilder<HoldTimerViewModel, HoldTimerUiState>(
      builder: (context, state) => AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topLeft,
        child: state.isRunning
            ? _Countdown(
                state: state,
                seconds: viewModel.seconds,
                onStop: viewModel.stop,
              )
            : Button(
                label: 'Start timer',
                variant: ButtonVariant.outlined,
                fullWidth: false,
                onPressed: viewModel.start,
              ),
      ),
    );
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({
    required this.state,
    required this.seconds,
    required this.onStop,
  });

  final HoldTimerUiState state;
  final int seconds;
  final VoidCallback onStop;

  static String _clock(int seconds) => seconds < 60
      ? '$seconds'
      : '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (text, style, color) = switch (state.stage) {
      HoldTimerStage.ready => (
        'Ready',
        AppTextStyles.display,
        colors.textSecondary,
      ),
      HoldTimerStage.set => (
        'Set',
        AppTextStyles.display,
        colors.textSecondary,
      ),
      HoldTimerStage.hold => (
        _clock(state.secondsLeft),
        AppTextStyles.numeric,
        state.secondsLeft <= 3 ? colors.accentPrimary : colors.textPrimary,
      ),
      HoldTimerStage.done || HoldTimerStage.idle => (
        'Done',
        AppTextStyles.display,
        colors.successPrimary,
      ),
    };
    final remaining = switch (state.stage) {
      HoldTimerStage.hold => (state.secondsLeft - 1) / seconds,
      HoldTimerStage.done || HoldTimerStage.idle => 0.0,
      _ => 1.0,
    };
    final numeric = AppTextStyles.numeric;

    return SizedBox(
      width: double.infinity,
      child: AppCard(
        child: Column(
          spacing: 8.h,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    'TIMER',
                    style: AppTextStyles.label,
                    color: colors.textSecondary,
                  ),
                ),
                Visibility(
                  visible: state.stage != HoldTimerStage.done,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Button(
                    label: 'Stop',
                    variant: ButtonVariant.text,
                    fullWidth: false,
                    onPressed: onStop,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: numeric.fontSize! * numeric.height!,
              child: Center(
                child: AppText(text, style: style, color: color, maxLines: 1),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: remaining),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) => ClipRRect(
                borderRadius: BorderRadius.circular(3.r),
                child: Container(
                  height: 6.h,
                  color: colors.bgTertiary,
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    heightFactor: 1,
                    child: ColoredBox(color: colors.accentPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
