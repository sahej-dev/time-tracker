import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/responsive/responsive.dart';

import '../../types.dart';
import 'activities_form.dart';
import '../bloc/activities_bloc.dart';
import '../../constants/constants.dart';
import '../../widgets/widgets.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ActivitiesPage());
  }

  @override
  Widget build(BuildContext context) {
    return const _ActivitiesPageView();
  }

  static PreferredSizeWidget Function() appBarBuilder() {
    return () => AppBar(
          title: const Text("Manage Activities"),
        );
  }

  static Widget Function() fabBuilder() {
    return () => const _AddActivityFloatingActionButton();
  }
}

class _ActivitiesPageView extends StatelessWidget {
  const _ActivitiesPageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, state) {
        switch (state.loadingStatus) {
          case LoadingStatus.initial:
          case LoadingStatus.pending:
            return const LoadingIndicator();

          case LoadingStatus.error:
            return ErrorDisplay(
              error: state.exception,
            );

          case LoadingStatus.success:
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: GridView.builder(
                itemCount: state.activities.length,
                itemBuilder: (context, index) {
                  final activity = state.activities[index];
                  return ActivityGridTile(
                    activity: activity,
                    onTap: () {
                      ActivityForm.showAddEditBottomSheet(
                        context: context,
                        bloc: context.read<ActivitiesBloc>(),
                        activityId: activity.id,
                      );
                    },
                  );
                },
                gridDelegate: Responsive.getDefaultGridDelegate(context),
              ),
            );
          default:
            return Text(
              "Uknown loading state ${state.loadingStatus}. Please contact developers",
              style: Theme.of(context).textTheme.bodyLarge,
            );
        }
      },
    );
  }
}

class _AddActivityFloatingActionButton extends StatelessWidget {
  const _AddActivityFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActivitiesBloc>();

    return AdaptiveFab(
      onPressed: () {
        ActivityForm.showAddEditBottomSheet(context: context, bloc: bloc);
      },
      child: const Icon(Icons.add),
    );
  }
}
