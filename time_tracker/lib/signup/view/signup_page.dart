import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'signup_form.dart';
import '../bloc/signup_bloc.dart';
import '../../responsive/responsive.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenType screenType = getScreenType(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider(
        create: (context) {
          return SignupBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          );
        },
        child: Builder(
          builder: (context) {
            const Widget child = SignupForm();

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
