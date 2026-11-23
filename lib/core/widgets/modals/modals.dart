import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/modals/confirmation_modal.dart';

class AppModals {
  static Future<dynamic> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String text,
    required String yesLabel,
    required Function() yesOnPress,
    required String noLabel,
    Function()? noOnPress,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: AppSpacing.fromLTRB(24, 24, 24, 24),
          child: Container(
            padding: AppSpacing.fromLTRB(24, 24, 24, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: context.colors.bgPrimary,
              border: Border.all(color: context.colors.borderDefault),
            ),
            child: ConfirmationModal(
              title: title,
              text: text,
              yesLabel: yesLabel,
              yesOnPress: yesOnPress,
              noLabel: noLabel,
              noOnPress: noOnPress,
            ),
          ),
        );
      },
    );
  }
}
