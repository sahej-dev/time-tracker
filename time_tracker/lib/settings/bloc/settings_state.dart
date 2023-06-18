part of 'settings_bloc.dart';

enum AccentColorSource { material3, custom }

@JsonSerializable()
class SettingsState extends Equatable {
  const SettingsState({
    required this.themeMode,
    required this.themeModeName,
    required this.accentColorSource,
    this.accentColor,
  });

  const SettingsState.initial()
      : this(
          themeMode: ThemeMode.system,
          themeModeName: SettingsConstants.systemThemeName,
          accentColorSource: AccentColorSource.custom,
        );

  final ThemeMode themeMode;
  final String themeModeName;
  final AccentColorSource accentColorSource;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? accentColor;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? themeModeName,
    AccentColorSource? accentColorSource,
    Color? accentColor,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      themeModeName: themeModeName ?? this.themeModeName,
      accentColorSource: accentColorSource ?? this.accentColorSource,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        themeModeName,
        accentColorSource,
        accentColor,
      ];

  static int? _colorToJson(Color? color) => color?.value;
  static Color? _colorFromJson(int? value) =>
      value != null ? Color(value) : null;
}
