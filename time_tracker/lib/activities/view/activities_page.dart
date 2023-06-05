import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'activities_form.dart';
import '../bloc/activities_bloc.dart';
import '../../constants/constants.dart';
import '../../widgets/widgets.dart';
import '../../authentication/bloc/authentication_bloc.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ActivitiesPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivitiesBloc>(
      create: (context) => ActivitiesBloc(
        activitiesRepository: context.read<ActivitiesRepository>(),
      )..add(
          ActivitiesFetchRequested(
              userId: context.read<AuthenticationBloc>().state.user!.id),
        ),
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
          switch (state.loadingStatus) {
            case LoadingStatus.initial:
            case LoadingStatus.pending:
              return const LoadingIndicator();

            case LoadingStatus.success:
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: GridView.builder(
                  itemCount: state.activities.length,
                  itemBuilder: (context, index) {
                    final activity = state.activities[index];
                    return GridTile(
                      child: ActivityGridTile(
                        activity: activity,
                        onLongPress: () {
                          final ActivitiesBloc bloc =
                              context.read<ActivitiesBloc>();

                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Edit"),
                                    leading: const Icon(Icons.edit),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: const Text("Delete"),
                                    leading: const Icon(Icons.delete),
                                    onTap: () {
                                      bloc.add(
                                        ActivitiesDeleted(activity: activity),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Deleted activity ${activity.label}'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {
                                                bloc.add(
                                                  const ActivitiesTryUndoLastDeleted(),
                                                );
                                              },
                                            ),
                                            showCloseIcon: true,
                                          ),
                                        );
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: kDefaultPadding * 0.25,
                    mainAxisSpacing: kDefaultPadding * 0.25,
                  ),
                ),
              );
            default:
          }

          return Text(
            "Uknown loading state ${state.loadingStatus}. Please contact developers",
            style: Theme.of(context).textTheme.bodyLarge,
          );
        },
      )),
      floatingActionButton: const _AddActivityFloatingActionButton(),
    );
  }
}

class _AddActivityFloatingActionButton extends StatelessWidget {
  const _AddActivityFloatingActionButton();

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
