import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:activities_repository/activities_repository.dart';

import 'authentication/authentication.dart';
import 'color_schemes.g.dart';
import 'activities/activities.dart';
import 'login/login.dart';
import 'splash/splash.dart';

class App extends StatefulWidget {
  const App({super.key, required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository(secureStorage: widget.secureStorage);
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider<UserRepository>.value(
          value: _userRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: AppView(
          secureStorage: widget.secureStorage,
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key, required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  ThemeData _buildTheme(
    Brightness brightness,
    Function gFontTextThemeGenerator,
    ColorScheme colorScheme,
  ) {
    late final ThemeData baseTheme;
    if (brightness == Brightness.light) {
      baseTheme = ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: colorScheme.harmonized(),
      );
    } else {
      baseTheme = ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: colorScheme.harmonized(),
      );
    }

    return baseTheme.copyWith(
        textTheme: gFontTextThemeGenerator(baseTheme.textTheme));
  }

  @override
  Widget build(BuildContext context) {
    const TextTheme Function([TextTheme?]) textThemeGenerator =
        GoogleFonts.montserratTextTheme;

    return BlocSelector<AuthenticationBloc, AuthenticationState,
        AuthenticationStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, authStatus) {
        return MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) {
                  switch (authStatus) {
                    case AuthenticationStatus.authenticated:
                      return MultiRepositoryProvider(
                        providers: [
                          RepositoryProvider(
                            create: (context) => ActivitiesRepository(
                              secureStorage: widget.secureStorage,
                              userId: context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user!
                                  .id,
                            ),
                          )
                        ],
                        child: const ActivitiesPage(),
                      );
                    case AuthenticationStatus.unauthenticated:
                      return const LoginPage();
                    case AuthenticationStatus.unknown:
                      return const SplashPage();
                  }
                },
              ),
            ],
          ),
          title: 'Flutter Demo',
          theme: _buildTheme(
            Brightness.light,
            textThemeGenerator,
            lightColorScheme,
          ),
          darkTheme: _buildTheme(
            Brightness.dark,
            textThemeGenerator,
            darkColorScheme,
          ),
          themeMode: ThemeMode.dark,
        );
      },
    );
  }
}
