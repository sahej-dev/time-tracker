import 'package:flavor/flavor.dart';
import 'package:time_tracker/config/config.dart';

import 'main.dart';

void main() {
  Flavor.create(
    Environment.dev,
    properties: {
      Keys.apiUrl: Config.devBaseUrl(),
    },
  );
  mainDelegate();
}
