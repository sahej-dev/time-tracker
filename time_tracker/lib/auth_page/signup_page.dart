import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/widgets.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding * 1.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedCard(
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultPadding * 2),
                    child: Column(
                      children: [
                        Hero(
                          tag: "signup_label",
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding * 3.5),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email/Username",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                          ),
                          obscureText: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: kDefaultPadding * 1.5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Login"),
                              ),
                            ),
                            const SizedBox(
                              width: kDefaultPadding,
                            ),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {},
                                child: const Text("Sign Up"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
