import 'package:flavor/flavor.dart';
import 'package:time_tracker/config/config.dart';

import 'main.dart';

void main() {
  Flavor.create(
    Environment.production,
    properties: {
      Keys.apiUrl: Config.prodBaseUrl,
    },
  );
  mainDelegate();
}
