// Guardian Angel — Phase 3: rolling 250x6 window + threshold gate (pure Dart).
// Platform sensor/TFLite specifics stay behind `inference.dart` conditional import,
// so web CI stays green and mobile gets real inference.
import 'model/config.dart';
import 'inference.dart';

typedef SeizureCallback = void Function(double probability);

class Detector {
  final List<List<double>> _buf = [];
  final SeizureCallback onSeizure;
  bool _modelReady = false;

  Detector({required this.onSeizure});

  Future<void> init() async {
    _modelReady = await initInference(ModelConfig.assetPath);
  }

  /// Push one IMU sample: [ax, ay, az, gx, gy, gz]. Returns probability when
  /// the window fills, else null. Sliding: drops oldest sample each time.
  Future<double?> pushSample(List<double> sample) async {
    assert(sample.length == ModelConfig.channels);
    _buf.add(sample);
    if (_buf.length < ModelConfig.windowLength) return null;
    if (_buf.length > ModelConfig.windowLength) {
      _buf.removeRange(0, _buf.length - ModelConfig.windowLength);
    }
    final p = _modelReady ? await runInference(_buf) : _fallback();
    if (p >= ModelConfig.threshold) onSeizure(p);
    return p;
  }

  // Web / no-model fallback: always below threshold (never false-alarms).
  // Prototype UI drives its own simulated flow instead.
  double _fallback() => 0.0;

  void reset() => _buf.clear();
  int get buffered => _buf.length;
}
