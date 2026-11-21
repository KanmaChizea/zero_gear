import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/features/auth/ui/views/login_view.dart';

import 'app_route.dart';

List<RouteBase> authRoutes() => [
  AppRoute.login.toGoRoute((_) => const LoginView()),
];

/// - Session not resolved yet: everything waits on the splash.
/// - Splash, once resolved: landing if signed in, otherwise login.
/// - Signed out: non-public routes go to login.
/// - Signed in: login goes to the landing.
/// - Signed in without a profile: everything but the onboarding screens goes
///   to onboarding.
///
/// The landing is home (or `from`) for an onboarded user, otherwise onboarding.
///
/// The original destination is carried in `?from=` through splash and login,
/// so deep links survive the redirects.
String? authRedirect(SessionCubit session, GoRouterState state) {
  final route = AppRoute.fromName(state.topRoute?.name);
  final location = state.uri.toString();
  final from = state.uri.queryParameters['from'];

  if (route == AppRoute.home) {
    return session.isSignedIn
        ? _landing(session, from)
        : _withFrom(AppRoute.login.path, from);
  }

  if (!session.isSignedIn) {
    if (route?.isPublic ?? false) return null;
    return _withFrom(AppRoute.login.path, location);
  }

  if (route == AppRoute.login) return _landing(session, from);

  final onboarded = session.user?.isOnboarded ?? false;
  if (!onboarded && !_onboardingRoutes.contains(route)) {
    return AppRoute.onboardingIntro.path;
  }
  return null;
}

const _onboardingRoutes = {
  AppRoute.onboardingIntro,
  AppRoute.onboarding,
  AppRoute.onboardingComplete,
};

String _landing(SessionCubit session, String? from) =>
    session.user?.isOnboarded ?? false
    ? _safeReturnPath(from) ?? AppRoute.home.path
    : AppRoute.onboardingIntro.path;

String _withFrom(String path, String? from) {
  final returnPath = _safeReturnPath(from);
  final keep = returnPath != null && returnPath != AppRoute.home.path;
  return Uri(
    path: path,
    queryParameters: keep ? {'from': returnPath} : null,
  ).toString();
}

/// Only in-app paths, and never back to splash or login.
String? _safeReturnPath(String? from) {
  if (from == null || !from.startsWith('/') || from.startsWith('//')) {
    return null;
  }
  final path = Uri.tryParse(from)?.path;
  if (path == AppRoute.login.path) return null;
  return from;
}
