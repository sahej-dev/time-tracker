import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'responsive/responsive.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.navigationShell,
    required this.appBarBuilders,
    required this.floatingActionButtonBuilders,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;
  final List<PreferredSizeWidget? Function()> appBarBuilders;
  final List<Widget? Function()> floatingActionButtonBuilders;

  final List<IconData> _icons = const [
    MdiIcons.clipboardListOutline,
    Icons.history_outlined,
    Icons.edit_outlined,
    Icons.settings_outlined,
  ];
  final List<IconData> _selectedIcons = const [
    MdiIcons.clipboardList,
    Icons.history,
    Icons.edit,
    Icons.settings,
  ];
  final List<String> _navLabels = const [
    "Logs",
    "History",
    "Activities",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    ScreenType screenType = getScreenType(context);

    Widget? fab = floatingActionButtonBuilders[navigationShell.currentIndex]();
    Widget bottomNavBar = NavigationBar(
      destinations: List.generate(
        navigationShell.route.branches.length,
        (index) => NavigationDestination(
          icon: Icon(_icons[index]),
          selectedIcon: Icon(_selectedIcons[index]),
          label: _navLabels[index],
        ),
      ),
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (int index) => _onTap(context, index),
      animationDuration: const Duration(milliseconds: 500),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );

    Widget navRail = NavigationRail(
      leading: fab ??
          const FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
      destinations: List.generate(
        navigationShell.route.branches.length,
        (index) => NavigationRailDestination(
          icon: Icon(_icons[index]),
          selectedIcon: Icon(_selectedIcons[index]),
          label: Text(_navLabels[index]),
        ),
      ),
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (int index) => _onTap(context, index),
      labelType: NavigationRailLabelType.all,
      groupAlignment: -0.8,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBarBuilders[navigationShell.currentIndex](),
      body: SafeArea(
        child: Builder(builder: (context) {
          if (screenType == ScreenType.mobile) return navigationShell;

          return Row(
            children: [
              navRail,
              Expanded(child: navigationShell),
            ],
          );
        }),
      ),
      floatingActionButton: screenType == ScreenType.mobile ? fab : null,
      bottomNavigationBar:
          screenType == ScreenType.mobile ? bottomNavBar : null,
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
