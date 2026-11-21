import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show FlutterAuthClientOptions, Supabase;
import 'package:zero_gear/core/config/env_config.dart';
import 'package:zero_gear/core/config/flavor.dart';
import 'package:zero_gear/features/auth/data/repositories/auth_repository.dart';
import 'package:zero_gear/features/auth/data/repositories/google_sign_in_repository.dart';
import 'package:zero_gear/features/auth/data/services/auth_service.dart';
import 'package:zero_gear/core/network/network_client.dart';
import 'package:zero_gear/core/router/app_router.dart';
import 'package:zero_gear/core/shared_features/session/data/services/session_cubit.dart';
import 'package:zero_gear/core/storage/local_storage.dart';
import 'package:zero_gear/core/storage/secure_session_storage.dart';
import 'package:zero_gear/core/theme/app_theme.dart';
import 'package:zero_gear/core/theme/theme_cubit.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/feedback/loader_host.dart';
import 'package:zero_gear/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ScaleUtil.init();
  await EnvConfig.init(Flavor.current);
  await Supabase.initialize(
    url: EnvConfig.baseUrl,
    publishableKey: EnvConfig.publishableKey,
    authOptions: FlutterAuthClientOptions(localStorage: SecureSessionStorage()),
  );
  final localStorage = await LocalStorage.create();

  final session = SessionCubit();
  final themeCubit = ThemeCubit(localStorage);
  final client = NetworkClient(Supabase.instance.client);
  final auth = AuthService(
    AuthRepository(client),
    GoogleSignInRepository(),
    session,
  );
  await auth.restoreSession();

  runApp(
    AppProvider(
      session: session,
      themeCubit: themeCubit,
      auth: auth,
      client: client,
      localStorage: localStorage,
      child: App(router: createAppRouter(session)),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Flavor.current.appName,
      debugShowCheckedModeBanner: !Flavor.current.isProd,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: context.watch<ThemeCubit>().state,
      routerConfig: router,
      builder: (context, child) {
        ScaleUtil.update(MediaQuery.sizeOf(context));
        return LoaderHost(child: child!);
      },
    );
  }
}
