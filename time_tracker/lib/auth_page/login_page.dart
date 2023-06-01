import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding * 1.5),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      const TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email/Username",
                          hintText: "you@amazing.com",
                        ),
                        autofocus: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: kDefaultPadding),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          hintText: "min. 8 characters",
                        ),
                        validator: (value) =>
                            value?.length != null && value!.length < 8
                                ? "min 8. characters required"
                                : "",
                        obscureText: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: kDefaultPadding * 1.5),
                      ),
                      FilledButton(
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Login"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    TextButton(onPressed: () {}, child: const Text("Sign up")),
                    Text(
                      "instead!",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
