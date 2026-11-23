import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_gear/core/audio/audio_guide.dart';
import 'package:zero_gear/core/shared_features/session/data/models/session_state.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/network/network_client.dart';
import 'package:zero_gear/core/storage/local_storage.dart';
import 'package:zero_gear/core/theme/theme_cubit.dart';
import 'package:zero_gear/features/auth/data/services/auth_service.dart';
import 'package:zero_gear/features/home/data/repositories/plan_repository.dart';
import 'package:zero_gear/features/home/data/repositories/workout_local_repository.dart';
import 'package:zero_gear/features/home/data/repositories/workout_repository.dart';
import 'package:zero_gear/features/home/data/services/home_service.dart';
import 'package:zero_gear/features/home/data/services/plan_service.dart';
import 'package:zero_gear/features/home/data/services/workout_service.dart';
import 'package:zero_gear/features/profile/data/repositories/profile_repository.dart';
import 'package:zero_gear/features/profile/data/services/profile_service.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({
    super.key,
    required this.session,
    required this.themeCubit,
    required this.auth,
    required this.client,
    required this.localStorage,
    required this.child,
  });

  final SessionCubit session;
  final ThemeCubit themeCubit;
  final AuthService auth;
  final NetworkClient client;
  final LocalStorage localStorage;
  final Widget child;

  static Future<void> clearAll(BuildContext context) async {
    context.read<HomeService>().clear();
    context.read<ProfileService>().clear();
    context.read<PlanService>().clear();
    await context.read<WorkoutService>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: session),
        BlocProvider.value(value: themeCubit),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: localStorage),
          RepositoryProvider(create: (_) => AudioGuide()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: auth),
            BlocProvider(
              create: (_) =>
                  ProfileService(ProfileRepository(client), session),
            ),
            BlocProvider(create: (_) => PlanService(PlanRepository(client))),
            BlocProvider(
              create: (context) => WorkoutService(
                WorkoutRepository(client),
                WorkoutLocalRepository(localStorage),
                context.read<PlanService>(),
                session,
              ),
            ),
            BlocProvider(
              create: (context) => HomeService(
                session,
                context.read<PlanService>(),
                context.read<WorkoutService>(),
              ),
            ),
          ],
          child: BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) =>
                previous.isSignedIn && !current.isSignedIn,
            listener: (context, _) => clearAll(context),
            child: child,
          ),
        ),
      ),
    );
  }
}
