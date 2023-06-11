import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../activities/activities.dart';
import '../../constants/constants.dart';
import '../../types.dart';
import '../../widgets/widgets.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  static PreferredSizeWidget? Function() appBarBuilder() => () => AppBar(
        title: const Text("Log Activities"),
      );
  static PreferredSizeWidget? Function() fabBuilder() => () => null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, state) {
        switch (state.loadingStatus) {
          case LoadingStatus.initial:
          case LoadingStatus.pending:
            return const LoadingIndicator();

          case LoadingStatus.error:
            print("nice");
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
                  return GridTile(
                    child: ActivityGridTile(
                      activity: activity,
                      onTap: () {},
                      onLongPress: () {},
                    ),
                  );
                },
                gridDelegate: kDefaultGridDelegate,
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
