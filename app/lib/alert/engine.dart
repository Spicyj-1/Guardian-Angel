// Guardian Angel — Phase 4: escalation state machine (pure Dart).
// PRD 5.2: cancel countdown (UI) → first caregiver → retry → next → …
// → clinic/emergency fallback. Unlimited list. Channel senders injectable:
// LocalLogSender ships now (offline-safe); TwilioSender/ResendSender/FcmSender
// plug in when keys exist (keys in .env, never committed — PRD Appendix D).
import 'emergency_data.dart';

enum AlertPhase { idle, awaitingCancel, escalating, fallback, resolved }

enum AlertOutcome { cancelled, acknowledged, fallbackShown }

/// One send attempt. Providers implement this (log now, Twilio/Resend later).
abstract class ChannelSender {
  String get name;
  Future<bool> send({required String to, required String message});
}

/// Offline-safe default: records the attempt for the History log.
class LocalLogSender implements ChannelSender {
  final List<String> outbox = [];
  @override
  String get name => 'local-log';
  @override
  Future<bool> send({required String to, required String message}) async {
    outbox.add('[$name → $to] $message');
    return true;
  }
}

class Caregiver {
  final String name;
  final String contact;
  int attempts = 0;
  Caregiver({required this.name, required this.contact});
}

class AlertEngine {
  final List<Caregiver> caregivers;
  final ChannelSender sender;
  final int maxAttemptsPerCaregiver;
  AlertPhase phase = AlertPhase.idle;
  int _index = 0;
  final List<String> trace = [];

  AlertEngine({
    required this.caregivers,
    required this.sender,
    this.maxAttemptsPerCaregiver = 2,
  });

  void start({required double probability, String? locationNote}) {
    phase = AlertPhase.awaitingCancel;
    _index = 0;
    trace.add('detection p=$probability ${locationNote ?? ''}');
  }

  void cancel() {
    phase = AlertPhase.resolved;
    trace.add('patient cancelled (okay)');
  }

  /// Called when the 12s countdown expires or an ack window lapses.
  /// Returns the resolution, or null if escalation continues.
  Future<AlertOutcome?> escalateDue({String? locationNote}) async {
    if (phase == AlertPhase.resolved) return AlertOutcome.cancelled;
    if (caregivers.isEmpty) {
      phase = AlertPhase.fallback;
      trace.add('no caregivers → fallback');
      return AlertOutcome.fallbackShown;
    }
    final c = caregivers[_index];
    c.attempts++;
    final msg = '🚨 Guardian Angel: possible seizure.'
        '${locationNote != null ? ' Location: $locationNote.' : ''}'
        ' Reply ACK if responding.';
    final ok = await sender.send(to: c.contact, message: msg);
    trace.add('alert → ${c.name} (attempt ${c.attempts}, sent=$ok)');
    if (c.attempts >= maxAttemptsPerCaregiver) {
      if (_index + 1 < caregivers.length) {
        _index++;
        phase = AlertPhase.escalating;
        trace.add('escalate → ${caregivers[_index].name}');
        return null;
      }
      phase = AlertPhase.fallback;
      trace.add('all caregivers exhausted → fallback');
      return AlertOutcome.fallbackShown;
    }
    phase = AlertPhase.escalating;
    return null;
  }

  void acknowledge(String caregiverName) {
    phase = AlertPhase.resolved;
    trace.add('$caregiverName acknowledged');
  }

  /// Last-resort numbers/text for the fallback screen (PRD 5.2 step 5).
  /// Prefers nearest bundled clinic; else country general number.
  String fallbackText({double? lat, double? lng, String country = 'Default'}) {
    if (lat != null && lng != null) {
      final clinic = nearestClinic(lat, lng);
      if (clinic != null) {
        return 'Nearest facility: ${clinic.name}, ${clinic.address}. '
            'Emergency: ${clinic.emergencyContact}.';
      }
    }
    final nums = emergencyNumbers[country] ?? emergencyNumbers['Default']!;
    return 'Call emergency now — ambulance ${nums['ambulance']}, '
        'police ${nums['police']}, general ${nums['general']}.';
  }
}
