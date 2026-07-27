import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile.dart';
import 'carp_health_hub.dart';
import 'health_hub.dart';
import 'ingest_service.dart';

final healthHubProvider = Provider<HealthHub>((_) => CarpHealthHub());

final healthIngestServiceProvider = Provider<HealthIngestService>((ref) {
  return HealthIngestService(
    database: ref.watch(databaseProvider),
    hub: ref.watch(healthHubProvider),
  );
});
