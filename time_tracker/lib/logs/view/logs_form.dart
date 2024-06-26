import 'package:flutter/material.dart';

import 'package:realtime_activities_repository/realtime_activities_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_instances_repository/realtime_instances_repository.dart';
import 'package:moment_dart/moment_dart.dart';

import 'widgets/widgets.dart';
import '../bloc/logs_bloc.dart';
import '../../activities/activities.dart';
import '../../constants/constants.dart';

class LogsForm extends StatefulWidget {
  const LogsForm({
    super.key,
    this.instance,
  });

  final ActivityInstance? instance;

  @override
  State<LogsForm> createState() => _LogsFormState();

  static Future<T?> showAddEditBottomSheet<T>(
    BuildContext context, {
    ActivityInstance? instance,
  }) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 2,
          ),
          child: LogsForm(
            instance: instance,
          ),
        );
      },
    );
  }
}

class _LogsFormState extends State<LogsForm> {
  late Activity? selectedActivity;
  late DateTime chosenStartDateTime;
  late DateTime? chosenEndDateTime;

  @override
  void initState() {
    super.initState();

    if (widget.instance == null) {
      selectedActivity = null;
      chosenStartDateTime = DateTime.now();
      chosenEndDateTime = null;
    } else {
      selectedActivity =
          context.read<LogsBloc>().state.activityForInstance(widget.instance!);
      chosenStartDateTime = widget.instance!.startAt;
      chosenEndDateTime = widget.instance!.endAt;
    }
  }

  bool isFormValid() {
    if (selectedActivity == null) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.instance == null ? "Create a Log" : "Edit a Log",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding * 1.75)),
        ActivityChooserField(
          selectedActivity: selectedActivity,
          labelText: "Choose activity",
          onTap: () async {
            Activity? chosenActivity = await showDialog<Activity?>(
              context: context,
              builder: (context) {
                return ActivityChooserDialog(
                  activitiesBloc: context.read<ActivitiesBloc>(),
                );
              },
            );

            if (chosenActivity != null && chosenActivity != selectedActivity) {
              setState(() {
                selectedActivity = chosenActivity;
              });
            }
          },
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding * 1.75)),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Start date",
                ),
                controller: TextEditingController(
                  text: chosenStartDateTime.toMoment().toLocal().formatDate(),
                ),
                onTap: () async {
                  // showTimePicker(context: context, initialTime: TimeOfDay.now());
                  DateTime? tappedDateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2100),
                  );
                  if (tappedDateTime != null) {
                    setState(() {
                      chosenStartDateTime = tappedDateTime;
                    });
                  }
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Start time",
                ),
                controller: TextEditingController(
                  text: chosenStartDateTime.toMoment().toLocal().formatTime(),
                ),
                onTap: () async {
                  // showTimePicker(context: context, initialTime: TimeOfDay.now());
                  TimeOfDay? tappedTimeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(chosenStartDateTime),
                  );
                  if (tappedTimeOfDay != null) {
                    setState(() {
                      chosenStartDateTime = chosenStartDateTime.copyWith(
                        hour: tappedTimeOfDay.hour,
                        minute: tappedTimeOfDay.minute,
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding * 1.75)),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "End date",
                ),
                controller: TextEditingController(
                  text: chosenEndDateTime?.toMoment().toLocal().formatDate(),
                ),
                onTap: () async {
                  DateTime? tappedDateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2100),
                  );

                  if (tappedDateTime != null) {
                    // set default end time to current time
                    final DateTime now = DateTime.now();
                    tappedDateTime = tappedDateTime.copyWith(
                      hour: now.hour,
                      minute: now.minute,
                      second: now.second,
                      millisecond: now.millisecond,
                      microsecond: now.microsecond,
                    );
                    setState(() {
                      chosenEndDateTime = tappedDateTime;
                    });
                  }
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
            Expanded(
              child: TextField(
                enabled: chosenEndDateTime != null,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "End time",
                ),
                controller: TextEditingController(
                  text: chosenEndDateTime?.toMoment().toLocal().formatTime(),
                ),
                onTap: () async {
                  TimeOfDay? tappedTimeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(chosenEndDateTime!),
                  );
                  if (tappedTimeOfDay != null) {
                    setState(() {
                      chosenEndDateTime = chosenEndDateTime?.copyWith(
                        hour: tappedTimeOfDay.hour,
                        minute: tappedTimeOfDay.minute,
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.topLeft,
          children: [
            if (chosenEndDateTime != null)
              TextButton(
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.only(left: 1)),
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                onPressed: () {
                  setState(() {
                    chosenEndDateTime = null;
                    FocusScope.of(context).unfocus();
                  });
                },
                child: const Text("Clear end date"),
              ),
            Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding * 2.25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(left: kDefaultPadding)),
                  FilledButton(
                    onPressed: isFormValid()
                        ? () {
                            if (widget.instance != null) {
                              context.read<LogsBloc>().add(LogsInstanceEdited(
                                      instance: widget.instance!.copyWith(
                                    startAt: chosenStartDateTime.toLocal(),
                                    endAt: chosenEndDateTime?.toLocal(),
                                    activityId: selectedActivity!.id,
                                  )));
                            } else {
                              context.read<LogsBloc>().add(
                                    LogsInstanceAdded(
                                      instance: ActivityInstance(
                                        startAt: chosenStartDateTime.toLocal(),
                                        endAt: chosenEndDateTime?.toLocal(),
                                        activityId: selectedActivity!.id,
                                      ),
                                    ),
                                  );
                            }

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.instance == null
                                        ? "Logged activity"
                                        : "Edited Log",
                                  ),
                                ),
                              );

                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text("Done"),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
