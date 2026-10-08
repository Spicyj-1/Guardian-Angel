// Guardian Angel — Phase 3: sampling + heartbeat wiring (mobile).
// Web build never imports this file (see detector.dart conditional backend).
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'detector.dart';

typedef LapseCallback = void Function(DateTime lastActive);

class MonitoringService {
  final Detector detector;
  final LapseCallback onLapse;
  final Duration lapseAfter;
  StreamSubscription? _acc;
  StreamSubscription? _gyro;
  Timer? _watchdog;
  DateTime _lastActive = DateTime.now();
  double _gx = 0, _gy = 0, _gz = 0;

  MonitoringService({
    required this.detector,
    required this.onLapse,
    this.lapseAfter = const Duration(minutes: 2),
  });

  Future<void> start() async {
    await detector.init();
    _gyro = gyroscopeEvents.listen((e) {
      _gx = e.x;
      _gy = e.y;
      _gz = e.z;
    });
    _acc = accelerometerEvents.listen((e) {
      _lastActive = DateTime.now();
      // Fire-and-forget: window/threshold logic lives in Detector.
      detector.pushSample([e.x, e.y, e.z, _gx, _gy, _gz]);
    });
    _watchdog = Timer.periodic(const Duration(minutes: 1), (_) {
      if (DateTime.now().difference(_lastActive) > lapseAfter) {
        onLapse(_lastActive); // PRD 5.3: notify with last-active timestamp.
      }
    });
  }

  DateTime get lastActive => _lastActive;

  Future<void> stop() async {
    await _acc?.cancel();
    await _gyro?.cancel();
    _watchdog?.cancel();
    detector.reset();
  }
}
