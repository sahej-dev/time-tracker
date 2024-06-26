import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'login_form.dart';
import '../bloc/login_bloc.dart';
import '../../responsive/responsive.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          );
        },
        child: Builder(
          builder: (context) {
            const Widget child = LoginForm();

            if (screenType == ScreenType.mobile) return child;

            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
