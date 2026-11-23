import 'package:zero_gear/features/home/data/models/exercise.dart';
import 'package:zero_gear/features/home/ui/views/active_stretch/active_stretch_view.dart';
import 'package:zero_gear/features/home/ui/views/active_workout/active_workout_view.dart';
import 'package:zero_gear/features/home/ui/views/day_detail/day_detail_view.dart';
import 'package:zero_gear/features/home/ui/views/exercise_detail/exercise_detail_view.dart';
import 'package:zero_gear/features/home/ui/views/home_view.dart';
import 'package:zero_gear/features/home/ui/views/stretch_offer/stretch_offer_view.dart';
import 'package:zero_gear/features/home/ui/views/workout_complete/workout_complete_view.dart';
import 'package:zero_gear/features/home/ui/views/workout_record/workout_record_view.dart';
import 'package:zero_gear/features/profile/ui/views/account_deleted/account_deleted_view.dart';
import 'package:zero_gear/features/profile/ui/views/appearance/appearance_view.dart';
import 'package:zero_gear/features/profile/ui/views/confirm_delete/confirm_delete_view.dart';
import 'package:zero_gear/features/profile/ui/views/delete_account/delete_account_view.dart';
import 'package:zero_gear/features/profile/ui/views/onboarding/onboarding_view.dart';
import 'package:zero_gear/features/profile/ui/views/onboarding/onboarding_complete_view.dart';
import 'package:zero_gear/features/profile/ui/views/onboarding/onboarding_intro_view.dart';
import 'package:zero_gear/features/profile/ui/views/profile_info/profile_info_view.dart';
import 'package:zero_gear/features/profile/ui/views/profile_view.dart';
import 'package:zero_gear/features/profile/ui/views/update_height_weight/update_height_weight_view.dart';
import 'package:zero_gear/features/profile/ui/views/weight_chart/weight_chart_view.dart';

import 'app_route.dart';

List<RouteBase> featureRoutes() => [
  AppRoute.home.toGoRoute(
    (_) => const HomeView(),
    routes: [
      AppRoute.stretchOffer.toGoRoute((_) => const StretchOfferView()),
      AppRoute.activeStretch.toGoRoute((_) => const ActiveStretchView()),
      AppRoute.activeWorkout.toGoRoute((_) => const ActiveWorkoutView()),
      AppRoute.workoutComplete.toGoRoute((_) => const WorkoutCompleteView()),
      AppRoute.dayDetail.toGoRoute(
        (state) => DayDetailView(day: int.parse(state.pathParameters['day']!)),
      ),
      AppRoute.exerciseDetail.toGoRoute(
        (state) => ExerciseDetailView(
          exercise: state.extra as Exercise,
          repCount: state.pathParameters['repCount'] ?? '',
        ),
      ),
      AppRoute.workoutRecord.toGoRoute(
        (state) => WorkoutRecordView(
          date: DateTime.parse(state.pathParameters['date']!),
        ),
      ),
    ],
  ),
  AppRoute.profile.toGoRoute(
    (_) => const ProfileView(),
    routes: [
      AppRoute.profileInfo.toGoRoute((_) => const ProfileInfoView()),
      AppRoute.updateHeightWeight.toGoRoute(
        (_) => const UpdateHeightWeightView(),
      ),
      AppRoute.weightChart.toGoRoute((_) => const WeightChartView()),
      AppRoute.appearance.toGoRoute((_) => const AppearanceView()),
      AppRoute.deleteAccount.toGoRoute(
        (_) => const DeleteAccountView(),
        routes: [
          AppRoute.confirmDelete.toGoRoute((_) => const ConfirmDeleteView()),
        ],
      ),
    ],
  ),
  AppRoute.onboardingIntro.toGoRoute((_) => const OnboardingIntroView()),
  AppRoute.onboarding.toGoRoute((_) => const OnboardingView()),
  AppRoute.onboardingComplete.toGoRoute((_) => const OnboardingCompleteView()),
  AppRoute.accountDeleted.toGoRoute((_) => const AccountDeletedView()),
];
