// Guardian Angel — Phase 5: trends + adherence math (pure Dart, tested via CI).
import '../data/repository.dart';

/// Weekly seizure counts for the last [weeks] weeks, oldest → newest.
/// Session events land in the final bucket; seed shapes the history curve.
List<int> weeklyCounts(List<SeizureEvent> events, {int weeks = 12}) {
  final counts = List<int>.filled(weeks, 0);
  const seed = [2, 3, 1, 4, 2, 5, 3, 2, 1, 3, 2, 4];
  for (int i = 0; i < weeks && i < seed.length; i++) {
    counts[i] = seed[seed.length - weeks + i];
  }
  final now = DateTime.now();
  for (final e in events) {
    final daysAgo = now.difference(e.at).inDays;
    if (daysAgo < 0 || daysAgo >= weeks * 7) continue;
    counts[weeks - 1 - (daysAgo ~/ 7)]++;
  }
  return counts;
}

/// Short human insight from the curve. Never a diagnosis (ethics: transparency).
String trendInsight(List<int> counts) {
  if (counts.isEmpty) return 'No data yet.';
  final recent = counts.sublist(counts.length - 4).reduce((a, b) => a + b);
  final prior = counts.sublist(0, counts.length - 4).reduce((a, b) => a + b);
  if (recent > prior) {
    return 'More frequent in the last 4 weeks — consider reviewing med timing with a clinician.';
  }
  if (recent < prior) return 'Frequency trending down vs earlier weeks. Keep it up.';
  return 'Steady pattern over the last 12 weeks.';
}

/// Adherence streak: consecutive evenings with a taken dose, ending today.
/// Computed from real records only — never assumed.
int adherenceStreak(MedsStore meds) {
  final evenings = meds.takenEvenings();
  int streak = 0;
  DateTime day = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  // If today's evening dose isn't taken yet, streak counts from yesterday.
  if (!evenings.contains(day)) {
    day = day.subtract(const Duration(days: 1));
  }
  while (evenings.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}
