import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:time_tracker/authentication/authentication.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/widgets.dart';
import '../../constants/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static PreferredSizeWidget Function() appBarBuilder() {
    return () => AppBar(
          title: const Text(SettingsConstants.appBarTitle),
        );
  }

  static Widget? Function() fabBuilder() {
    return () => null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  final SettingsBloc settingsBloc =
                      context.read<SettingsBloc>();

                  ThemeMode? newTheme = await showDialog(
                    context: context,
                    builder: (context) => ChoiceDialog<ThemeMode>(
                      options: const [
                        ThemeMode.light,
                        ThemeMode.dark,
                        ThemeMode.system,
                      ],
                      optionNames: const [
                        SettingsConstants.lightThemeName,
                        SettingsConstants.darkThemeName,
                        SettingsConstants.systemThemeName,
                      ],
                      initiallySelectedOption: state.themeMode,
                    ),
                  );

                  if (newTheme == null) return;

                  settingsBloc
                      .add(SettingsEventThemeModeChangeRequested(newTheme));
                },
                child: ListTile(
                  leading: const SettingsIcon(
                    Icons.color_lens_outlined,
                  ),
                  title: const Text(SettingsConstants.themeHeading),
                  subtitle: Text(state.themeModeName),
                ),
              ),
              if (Platform.isAndroid)
                ListTile(
                  leading: const SettingsIcon(MdiIcons.materialDesign),
                  title: const Text(SettingsConstants.useMaterial3Heading),
                  subtitle:
                      const Text(SettingsConstants.useMaterial3Subheading),
                  trailing: Switch.adaptive(
                    onChanged: (bool value) {
                      context
                          .read<SettingsBloc>()
                          .add(SettingsEventAccentSourceChangeRequested(
                            value
                                ? AccentColorSource.material3
                                : AccentColorSource.custom,
                          ));
                    },
                    value:
                        state.accentColorSource == AccentColorSource.material3,
                  ),
                ),
              const ThemeSeedColorTile(),
              const Divider(),
              TextButton(
                child: const Text(
                  "Log out",
                  textAlign: TextAlign.start,
                ),
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                        AuthenticationLogoutRequested(),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
