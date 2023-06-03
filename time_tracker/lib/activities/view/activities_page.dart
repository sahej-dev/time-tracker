import 'package:flutter/material.dart';

import 'activities_form.dart';
import '../../constants/constants.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ActivitiesPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(child: Container()),
      floatingActionButton: const AddActivityFloatingActionButton(),
    );
  }
}

class AddActivityFloatingActionButton extends StatelessWidget {
  const AddActivityFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return Container(
              width: double.maxFinite,
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
              // color: Colors.red,
              child: ActivityForm(
                defaultColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
