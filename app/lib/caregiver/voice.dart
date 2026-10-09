// Guardian Angel — Phase 6: voice check-in protocol (pure Dart).
// Ported from promivine voice_checkin.py IVR flow. Live calling (Twilio)
// plugs in behind VoiceGateway when keys exist (keys in .env, never committed).
// Offline rule: script + records work without any provider.

enum CheckinResponse { fine, help }

class CheckinRecord {
  final DateTime at;
  final CheckinResponse response;
  final String callerType; // 'patient' | 'caregiver'
  CheckinRecord({
    required this.at,
    required this.response,
    required this.callerType,
  });
  String get impliedRisk => response == CheckinResponse.help ? 'Moderate' : 'Low';
  bool get alertsCaregivers => response == CheckinResponse.help;
}

/// IVR script, verbatim logic from the Streamlit flow:
// 1. "Are you the patient or caregiver?" → 1 patient, 2 caregiver
// 2. "Press 1 I'm fine / 2 I need help" → logged; help alerts caregivers.
class IvrScript {
  static const greeting =
      'Welcome to Guardian Angel check-in. Are you the patient or caregiver? '
      'Press 1 for patient, 2 for caregiver.';
  static const statusPrompt =
      'Press 1 if you are fine. Press 2 if you need help.';
  static const fineReply = 'Thank you. You are marked fine and safe.';
  static const helpReply =
      'Help requested. Your caregivers are being alerted now.';
  static const checkinNumber = '+1 234 567 8900'; // replaced by Twilio number
}

abstract class VoiceGateway {
  Future<bool> placeCheckinCall({required String to, required String webhookUrl});
}

/// Offline-safe default: records intent; real call needs Twilio keys.
class LocalVoiceGateway implements VoiceGateway {
  final List<String> outbox = [];
  @override
  Future<bool> placeCheckinCall(
      {required String to, required String webhookUrl}) async {
    outbox.add('call → $to');
    return true;
  }
}
