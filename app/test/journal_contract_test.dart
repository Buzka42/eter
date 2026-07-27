import 'package:eter/core/aether/ai_contract.dart';
import 'package:eter/core/aether/guidance.dart';
import 'package:eter/core/aether/journal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a well-formed multi-segment extraction', () {
    final extraction = JournalExtraction.fromJson(_fixture());

    expect(extraction.segments, hasLength(4));
    expect(extraction.segments.first, isA<FoodJournalSegment>());
    expect(extraction.needsUserDetail, isTrue);
  });

  test('rejects malformed and empty segment responses', () {
    expect(
      () => JournalExtraction.fromJson({
        'schemaVersion': 1,
        'segments': const [],
        'model': 'test',
      }),
      throwsA(isA<AetherProtocolException>()),
    );
    expect(
      () => JournalExtraction.fromJson({
        'schemaVersion': 1,
        'segments': [
          {'kind': 'unknown'}
        ],
        'model': 'test',
      }),
      throwsA(isA<AetherProtocolException>()),
    );
  });

  test('rejects out-of-range values', () {
    final fixture = _fixture();
    final segments = fixture['segments']! as List<Object?>;
    (segments[1]! as Map<String, Object?>)['durationMinutes'] = 0;

    expect(
      () => JournalExtraction.fromJson(fixture),
      throwsA(isA<AetherProtocolException>()),
    );
  });

  test('journal prose is sent only to classification', () async {
    final transport = _CapturingTransport();
    final client = AetherClient(transport);
    const prose = 'SECRET JOURNAL PROSE';

    await client.classifyJournalEntry(
      text: prose,
      weightKg: 72,
      units: 'metric',
      locale: 'en',
    );
    expect(transport.requests.single.toString(), contains(prose));

    transport.requests.clear();
    await client.generateGuidance(
      context: GuidanceContext(
        now: DateTime.utc(2026, 7, 27),
        firstName: null,
        activeKcal: 120,
        steps: 4000,
        sessions: 1,
        zodiac: 'virgo',
        lifePath: 7,
        mode: GuidanceMode.grounded,
        lifestyle: const {
          'patterns': [
            {'summary': 'Computed aggregate only'}
          ],
        },
        symbolicContext: const {
          'lifePath': 7,
          'natalChart': {'private': 'full chart'},
        },
      ),
    );
    final request = transport.requests.single;
    expect(request.toString(), isNot(contains(prose)));
    final context = request['context']! as Map<String, Object?>;
    final symbolic = context['symbolicContext']! as Map<String, Object?>;
    expect(symbolic, containsPair('sunSign', 'virgo'));
    expect(symbolic, isNot(contains('natalChart')));

    transport.requests.clear();
    await client.synthesizeInsights(
      candidates: const [
        {
          'key': 'sleep-steps',
          'summary': 'Longer sleep precedes more steps.',
          'coefficient': .42,
          'n': 12,
          'window': 30,
          'journalText': prose,
        },
      ],
    );
    expect(transport.requests.single.toString(), isNot(contains(prose)));
  });
}

Map<String, Object?> _fixture() => {
      'schemaVersion': 1,
      'model': 'test',
      'segments': [
        {
          'kind': 'food',
          'confidence': .8,
          'items': [
            {
              'name': 'Porridge',
              'portion': 'one bowl',
              'kcal': 320,
              'proteinG': 12,
              'carbsG': 48,
              'fatG': 8,
            }
          ],
        },
        {
          'kind': 'activity',
          'name': 'walk',
          'durationMinutes': 35,
          'intensity': 'easy',
          'activeKcal': 140,
          'confidence': .7,
        },
        {'kind': 'mood', 'value': 4},
        {
          'kind': 'strength',
          'needsUserDetail': true,
          'exercises': [
            {
              'name': 'Squat',
              'sets': [
                {'reps': 5, 'weightKg': 80}
              ],
            }
          ],
        },
      ],
    };

class _CapturingTransport implements AetherTransport {
  final requests = <Map<String, Object?>>[];

  @override
  Future<Map<String, Object?>> invoke(Map<String, Object?> request) async {
    requests.add(request);
    return switch (request['task']) {
      'classify_journal_entry' => _fixture(),
      'synthesize_insights' => {
          'schemaVersion': 1,
          'insights': [
            {'key': 'sleep-steps', 'phrasing': 'A cautious phrasing.'}
          ],
          'model': 'test',
        },
      _ => {
          'schemaVersion': 1,
          'sentences': ['A safe aggregate-only sentence.'],
          'primaryAction': 'Take a short walk.',
          'model': 'test',
        },
    };
  }
}
