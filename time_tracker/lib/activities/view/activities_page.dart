import 'package:activities_repository/activities_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
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
                    final color = Color(
                      activity.color ??
                          Theme.of(context).colorScheme.surfaceTint.value,
                    ).harmonizeWith(Theme.of(context).colorScheme.primary);
                    return GridTile(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 12,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: color,
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                IconData(
                                  activity.icon.codepoint,
                                  fontFamily: activity.icon.metadata.fontFamily,
                                  fontPackage:
                                      activity.icon.metadata.fontPackage,
                                ),
                                color: color,
                                size: kDefaultIconSize * 1.5,
                              ),
                              Text(
                                activity.label,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
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
