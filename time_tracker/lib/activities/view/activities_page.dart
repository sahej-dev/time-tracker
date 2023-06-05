import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/activities/bloc/activities_bloc.dart';

import 'activities_form.dart';
import '../../constants/constants.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ActivitiesPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivitiesBloc>(
      create: (context) => ActivitiesBloc(
          activitiesRepository: context.read<ActivitiesRepository>()),
      child: const _ActivitiesPageView(),
    );
  }
}

class _ActivitiesPageView extends StatelessWidget {
  const _ActivitiesPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.activities.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(state.activities[index].label),
              tileColor: Color(
                state.activities[index].color ??
                    Theme.of(context).colorScheme.primary.value,
              ),
            ),
          );
        },
      )),
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
    final bloc = context.read<ActivitiesBloc>();
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
                activitiesBloc: bloc,
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
