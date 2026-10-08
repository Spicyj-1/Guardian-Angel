// Guardian Angel — model + alert config (Phase 1 specs, Phase 2 shell).
// Threshold is a CONFIG VALUE: retraining never requires code changes.

class ModelConfig {
  // Confirmed 27 Sept 2026 (Colab): input (250x6 float32), output (1) probability.
  static const int windowLength = 250;
  static const int channels = 6; // accel XYZ + gyro XYZ
  static const String assetPath = 'assets/seizure_detection_model.tflite';

  // TODO(Phase 1 sign-off): replace with recall-first threshold from sweep.
  // Pending founder's 0.05–0.30 sweep output. Default 0.5 = neutral, NOT tuned.
  static const double threshold = 0.5;

  // Alert flow (PRD 5.2).
  static const int cancelCountdownSeconds = 12;
}

// Clinical theme v2 (PRD Appendix B): light bg, navy headings, teal primary.
class AppTheme {
  static const int bg = 0xFFF2F7F6;
  static const int navy = 0xFF0B2A3A;
  static const int teal = 0xFF0E9F8A;
  static const int blue = 0xFF2563EB;
  static const int critical = 0xFFDC2626;
}
