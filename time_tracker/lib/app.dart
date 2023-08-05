import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:realtime_instances_repository/realtime_instances_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:realtime_activities_repository/realtime_activities_repository.dart';

import 'authentication/authentication.dart';
import 'color_schemes.g.dart';
import 'activities/activities.dart';
import 'login/login.dart';
import 'signup/signup.dart';
import 'logs/logs.dart';
import 'history/history.dart';
import 'settings/settings.dart';
import 'summary/summary.dart';
import 'splash/splash.dart';
import 'app_shell.dart';

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
    _authenticationRepository = AuthenticationRepository(
      secureStorage: widget.secureStorage,
      apiUrl: Flavor.I.getString(Keys.apiUrl)!,
    );
    _userRepository = UserRepository(
      secureStorage: widget.secureStorage,
      apiUrl: Flavor.I.getString(Keys.apiUrl)!,
    );
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
        child: AuthBasedRepositoryBlocProviderWidget(
          secureStorage: widget.secureStorage,
        ),
      ),
    );
  }
}

class AuthBasedRepositoryBlocProviderWidget extends StatefulWidget {
  const AuthBasedRepositoryBlocProviderWidget(
      {super.key, required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  State<AuthBasedRepositoryBlocProviderWidget> createState() =>
      _AuthBasedRepositoryBlocProviderWidgetState();
}

class _AuthBasedRepositoryBlocProviderWidgetState
    extends State<AuthBasedRepositoryBlocProviderWidget> {
  GoRouter getRouterConfig(AuthenticationStatus authStatus) {
    final GlobalKey<NavigatorState> rootNavigatorKey =
        GlobalKey<NavigatorState>(debugLabel: 'root');

    switch (authStatus) {
      case AuthenticationStatus.unknown:
        return GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const SplashPage(),
            ),
          ],
        );
      case AuthenticationStatus.unauthenticated:
        return GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/login',
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: '/signup',
              builder: (context, state) => const SignupPage(),
            ),
          ],
        );

      case AuthenticationStatus.authenticated:
        return GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/logs',
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (BuildContext context, GoRouterState state,
                  StatefulNavigationShell navigationShell) {
                return AppShell(
                  navigationShell: navigationShell,
                  appBarBuilders: [
                    LogsPage.appBarBuilder(),
                    SummaryPage.appBarBuilder(context),
                    HistoryPage.appBarBuilder(context),
                    ActivitiesPage.appBarBuilder(),
                    SettingsPage.appBarBuilder(),
                  ],
                  floatingActionButtonBuilders: [
                    LogsPage.fabBuilder(),
                    SummaryPage.fabBuilder(),
                    HistoryPage.fabBuilder(),
                    ActivitiesPage.fabBuilder(),
                    SettingsPage.fabBuilder(),
                  ],
                );
              },
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/logs',
                      name: 'Logs',
                      builder: (context, state) => const LogsPage(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/analytics',
                      name: 'Analytics',
                      builder: (context, state) => const SummaryPage(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/history',
                      name: 'History',
                      builder: (context, state) => const HistoryPage(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/activities',
                      name: 'Activities',
                      builder: (context, state) => const ActivitiesPage(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/settings',
                      name: 'Settings',
                      builder: (context, state) => const SettingsPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: BlocSelector<AuthenticationBloc, AuthenticationState,
          AuthenticationStatus>(
        selector: (state) {
          return state.status;
        },

        /// provides repositories & blocs that depend on authentication status
        builder: (context, authStatus) {
          final Widget app = AppView(
            goRouter: getRouterConfig(authStatus),
          );

          if (authStatus != AuthenticationStatus.authenticated) return app;

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) => RealtimeActivitiesRepository(
                  secureStorage: widget.secureStorage,
                  apiUrl: Flavor.I.getString(Keys.apiUrl)!,
                  socket: context.read<AuthenticationRepository>().socket!,
                ),
              ),
              RepositoryProvider(
                create: (context) => RealtimeInstancesRepository(
                  secureStorage: widget.secureStorage,
                  apiUrl: Flavor.I.getString(Keys.apiUrl)!,
                  socket: context.read<AuthenticationRepository>().socket!,
                ),
              ),
            ],
            child: Builder(builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ActivitiesBloc>(
                    create: (context) => ActivitiesBloc(
                      activitiesRepository:
                          context.read<RealtimeActivitiesRepository>(),
                    )..add(const ActivitiesSubscriptionRequested()),
                  ),
                  BlocProvider(
                    create: (context) => SummaryBloc(
                      activitiesRepository:
                          context.read<RealtimeActivitiesRepository>(),
                      instancesRepository:
                          context.read<RealtimeInstancesRepository>(),
                    )
                      ..add(const SummaryActivitiesSubscriptionRequested())
                      ..add(const SummaryLogsSubscriptionRequested()),
                  ),
                  BlocProvider(
                    create: (context) => LogsBloc(
                      activitiesRepository:
                          context.read<RealtimeActivitiesRepository>(),
                      instancesRepository:
                          context.read<RealtimeInstancesRepository>(),
                    )
                      ..add(const LogsActivitiesSubscriptionRequested())
                      ..add(const LogsSubscriptionRequested()),
                  ),
                  BlocProvider(
                    create: (context) => HistoryBloc(
                      activitiesRepository:
                          context.read<RealtimeActivitiesRepository>(),
                      instancesRepository:
                          context.read<RealtimeInstancesRepository>(),
                    )
                      ..add(const HistoryActivitiesSubscriptionsRequested())
                      ..add(
                        const HistoryLogsSubscriptionsRequested(),
                      ),
                  ),
                ],
                child: app,
              );
            }),
          );
        },
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    super.key,
    required this.goRouter,
  });

  final GoRouter goRouter;

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

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            ColorScheme lightPreferredScheme = state.accentColor == null
                ? lightColorScheme
                : ColorScheme.fromSeed(
                    seedColor: state.accentColor!,
                    brightness: Brightness.light,
                  );

            ColorScheme darkPreferredScheme = state.accentColor == null
                ? darkColorScheme
                : ColorScheme.fromSeed(
                    seedColor: state.accentColor!,
                    brightness: Brightness.dark,
                  );

            return MaterialApp.router(
              routerConfig: goRouter,
              title: 'Time Tracker',
              theme: _buildTheme(
                Brightness.light,
                textThemeGenerator,
                state.accentColorSource == AccentColorSource.material3
                    ? lightDynamic ?? lightPreferredScheme
                    : lightPreferredScheme,
              ),
              darkTheme: _buildTheme(
                Brightness.dark,
                textThemeGenerator,
                state.accentColorSource == AccentColorSource.material3
                    ? darkDynamic ?? darkPreferredScheme
                    : darkPreferredScheme,
              ),
              themeMode: state.themeMode,
            );
          },
        );
      },
    );
  }
}
