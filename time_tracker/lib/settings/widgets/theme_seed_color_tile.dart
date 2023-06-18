import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'settings_icon.dart';
import '../bloc/settings_bloc.dart';
import '../../constants/constants.dart';
import '../../widgets/widgets.dart';

class ThemeSeedColorTile extends StatelessWidget {
  const ThemeSeedColorTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        Color initialColor =
            state.accentColorSource == AccentColorSource.material3
                ? Theme.of(context).colorScheme.primary
                : state.accentColor ?? Theme.of(context).colorScheme.primary;

        final Widget child = ListTile(
          leading: const SettingsIcon(MdiIcons.eyedropperVariant),
          title: const Text(SettingsConstants.accentColorHeading),
          trailing: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: initialColor,
            ),
            width: kDefaultIconSize * 1.5,
          ),
          onTap: state.accentColorSource == AccentColorSource.custom
              ? () async {
                  final SettingsBloc settingsBloc =
                      context.read<SettingsBloc>();

                  final Color? res = await showDialog(
                    context: context,
                    builder: (context) => ColorPickerDialog(
                      allowCustom: true,
                      initialColor: initialColor,
                    ),
                  );

                  if (res == null) return;

                  settingsBloc.add(
                    SettingsEventAccentColorChangeRequested(res),
                  );
                }
              : null,
        );
        if (state.accentColorSource == AccentColorSource.material3) {
          return Opacity(opacity: kDefaultDisableOpacity, child: child);
        }

        return child;
      },
    );
  }
}
