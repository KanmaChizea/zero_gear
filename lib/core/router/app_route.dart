import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart';

/// Every route in the app. [name] is the enum name; [path] is relative for
/// nested routes. Navigate by name: `context.goNamed(AppRoute.home.name)`.
enum AppRoute {
  login('/login', isPublic: true),
  accountDeleted('/account-deleted', isPublic: true),
  home('/home'),
  stretchOffer('stretch-offer'),
  activeStretch('active-stretch'),
  activeWorkout('active-workout'),
  workoutComplete('workout-complete'),
  dayDetail('day-detail/:day([1-9]\\d*)'),
  exerciseDetail('exercise-detail/:repCount'),
  workoutRecord('workout-record/:date(\\d{4}-\\d{2}-\\d{2})'),
  profile('/profile'),
  profileInfo('profile-info'),
  updateHeightWeight('update-height-weight'),
  weightChart('weight-chart'),
  appearance('appearance'),
  deleteAccount('delete-account'),
  confirmDelete('confirm-delete'),
  onboardingIntro('/onboarding-intro'),
  onboarding('/onboarding'),
  onboardingComplete('/onboarding-complete');

  const AppRoute(this.path, {this.isPublic = false});

  final String path;

  final bool isPublic;

  static AppRoute? fromName(String? name) => AppRoute.values.asNameMap()[name];

  GoRoute toGoRoute(
    Widget Function(GoRouterState state) build, {
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      name: name,
      path: path,
      builder: (context, state) => build(state),
      routes: routes,
    );
  }
}
