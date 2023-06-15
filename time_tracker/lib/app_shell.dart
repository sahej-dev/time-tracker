import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  ];
  final List<IconData> _selectedIcons = const [
    MdiIcons.clipboardList,
    Icons.history,
    Icons.edit,
  ];
  final List<String> _navLabels = const [
    "Logs",
    "History",
    "Activities",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBarBuilders[navigationShell.currentIndex](),
      body: SafeArea(
        child: navigationShell,
      ),
      floatingActionButton:
          floatingActionButtonBuilders[navigationShell.currentIndex](),
      bottomNavigationBar: NavigationBar(
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
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
