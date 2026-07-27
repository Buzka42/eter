import '../db/app_database.dart';
import 'guidance.dart';

class GuidanceService {
  const GuidanceService({
    required this.database,
    required this.provider,
    this.minimumRefreshInterval = const Duration(minutes: 30),
  });

  final AppDatabase database;
  final GuidanceProvider provider;
  final Duration minimumRefreshInterval;

  Future<AetherGuidance> guidanceForOpen(GuidanceContext context) async {
    final cachedRow = await database.loadLatestGuidance();
    if (cachedRow != null) {
      try {
        final cached = AetherGuidance.fromJson(cachedRow.contentJson);
        final age = context.now.toUtc().difference(cached.generatedAt);
        if (!age.isNegative && age < minimumRefreshInterval) return cached;
      } on FormatException {
        // A corrupt or obsolete cache is replaced by validated guidance.
      }
    }

    final guidance = await provider.generate(context);
    await database.saveGuidance(
      generatedAt: guidance.generatedAt,
      contextFingerprint: guidance.contextFingerprint,
      contentJson: guidance.toJson(),
      source: guidance.source,
    );
    return guidance;
  }
}
