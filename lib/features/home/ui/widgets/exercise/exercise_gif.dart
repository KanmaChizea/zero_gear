import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

class ExerciseGif extends StatelessWidget {
  const ExerciseGif({super.key, required this.url, this.heroTag});

  final String? url;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    final gif = AspectRatio(
      aspectRatio: 342 / 260,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: context.colors.bgTertiary,
          image: url != null && !kIsWeb
              ? DecorationImage(image: CachedNetworkImageProvider(url))
              : null,
        ),

        child: url != null && kIsWeb
            ? Image.network(
                url,
                fit: BoxFit.scaleDown,
                webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              )
            : null,
      ),
    );
    final tag = heroTag;
    return tag == null ? gif : Hero(tag: 'exercise-gif-$tag', child: gif);
  }
}
