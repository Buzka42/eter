import 'package:eter/core/aether/guidance.dart';
import 'package:eter/core/aether/guidance_service.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('life path preserves master numbers', () {
    expect(calculateLifePath(DateTime(1990, 8, 1)), 1);
    expect(calculateLifePath(DateTime(2000, 1, 8)), 11);
  });

  test('guidance is reused inside the refresh interval', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final provider = _CountingProvider();
    final service = GuidanceService(database: database, provider: provider);
    final now = DateTime.utc(2026, 7, 24, 8);
    final context = GuidanceContext(
      now: now,
      firstName: null,
      activeKcal: 0,
      steps: 0,
      sessions: 0,
      zodiac: 'Leo',
      lifePath: 1,
      mode: GuidanceMode.balanced,
    );

    final first = await service.guidanceForOpen(context);
    final second = await service.guidanceForOpen(
      GuidanceContext(
        now: now.add(const Duration(minutes: 5)),
        firstName: null,
        activeKcal: 200,
        steps: 4000,
        sessions: 1,
        zodiac: 'Leo',
        lifePath: 1,
        mode: GuidanceMode.balanced,
      ),
    );

    expect(provider.calls, 1);
    expect(second.sentences, first.sentences);
  });
}

class _CountingProvider implements GuidanceProvider {
  int calls = 0;

  @override
  Future<AetherGuidance> generate(GuidanceContext context) async {
    calls++;
    return AetherGuidance(
      sentences: const ['Test guidance.'],
      generatedAt: context.now,
      source: 'test',
      contextFingerprint: context.fingerprint,
    );
  }
}
