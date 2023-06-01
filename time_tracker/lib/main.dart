import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_tracker/auth_page/login_page.dart';

import 'color_schemes.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(
      Brightness brightness, Function gFontTextThemeGenerator) {
    late final ThemeData baseTheme;
    if (brightness == Brightness.light) {
      baseTheme = ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: lightColorScheme.harmonized(),
      );
    } else {
      baseTheme = ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkColorScheme.harmonized(),
      );
    }

    return baseTheme.copyWith(
        textTheme: gFontTextThemeGenerator(baseTheme.textTheme));
  }

  @override
  Widget build(BuildContext context) {
    const TextTheme Function([TextTheme?]) textThemeGenerator =
        GoogleFonts.montserratTextTheme;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: _buildTheme(Brightness.light, textThemeGenerator),
      darkTheme: _buildTheme(Brightness.dark, textThemeGenerator),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      themeMode: ThemeMode.dark,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
