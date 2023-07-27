import 'package:equatable/equatable.dart';
import 'package:activities_repository/activities_repository.dart';

class Statistic extends Equatable {
  final Activity activity;
  final Duration duration;
  final double percentage;

  const Statistic({
    required this.activity,
    required this.duration,
    required this.percentage,
  });

  @override
  List<Object?> get props => [activity, duration, percentage];
}
