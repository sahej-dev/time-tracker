import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../bloc/signup_bloc.dart';
import '../../constants/constants.dart';
import '../../widgets/widgets.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Unable to signup. Please try again later.'),
                showCloseIcon: true,
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTitle(
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                ),
                Text(
                  AppConstants.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding * 3.5),
                ),
                _FullNameInput(),
                const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                ),
                _UsernameInput(),
                const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                ),
                _PasswordInput(),
                const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding * 1.5),
                ),
                _SignupButton(),
                const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding * 1.5),
                ),
                const _LoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.fullName != current.fullName,
      builder: (context, state) {
        return TextField(
          autofocus: true,
          onChanged: (name) =>
              context.read<SignupBloc>().add(SignupFullNameChanged(name)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Full name',
            hintText: "What do we call you?",
            errorText:
                state.fullName.displayError != null ? 'cannot be empty' : null,
          ),
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          autofocus: true,
          onChanged: (email) =>
              context.read<SignupBloc>().add(SignupEmailChanged(email)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Email/Username',
            hintText: "you@amazing.com",
            errorText:
                state.email.displayError != null ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            hintText: "min. 8 characters",
            errorText:
                state.password.displayError != null ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextField(
          autofocus: true,
          onChanged: (phone) =>
              context.read<SignupBloc>().add(SignupPhoneChanged(phone)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Phone number',
            hintText: "How do we reach you?",
            errorText: state.phone.displayError != null
                ? 'invalid phone number'
                : null,
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : FilledButton(
                onPressed: state.isValid
                    ? () {
                        context.read<SignupBloc>().add(const SignupSubmitted());
                      }
                    : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign up"),
                  ],
                ),
              );
      },
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already a member?",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        TextButton(
            onPressed: () {
              context.go('/login');
            },
            child: const Text("Login")),
        Text(
          "instead!",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ],
    );
  }
}
