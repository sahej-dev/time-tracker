import 'package:moment_dart/moment_dart.dart';

extension DurationExtension on Duration {
  String get toPrettyString => toDurationString(
        form: UnitStringForm.short,
        dropPrefixOrSuffix: true,
        format: DurationFormat.hm,
      );
}
