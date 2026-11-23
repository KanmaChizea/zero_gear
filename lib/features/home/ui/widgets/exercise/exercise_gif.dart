import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class ExerciseGif extends StatelessWidget {
  const ExerciseGif({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 342 / 260,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: context.colors.bgTertiary,
          image: url != null
              ? DecorationImage(image: CachedNetworkImageProvider(url!))
              : null,
        ),
      ),
    );
  }
}
