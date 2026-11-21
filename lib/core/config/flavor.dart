import 'package:flutter/services.dart';

enum Flavor {
  dev('Zero Gear Dev'),
  staging('Zero Gear Staging'),
  prod('Zero Gear');

  const Flavor(this.appName);

  final String appName;

  bool get isProd => this == Flavor.prod;

  static final Flavor current = Flavor.values.firstWhere(
    (f) => f.name == appFlavor,
    orElse: () => throw StateError('Unknown flavor: $appFlavor'),
  );
}
