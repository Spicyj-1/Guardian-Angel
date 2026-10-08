// Mobile backend: TFLite with SELECT_TF_OPS (LSTM requirement, PRD Appendix A).
// Input: [1, 250, 6] float32 signal_input. Output: [1, 1] seizure probability.
import 'package:tflite_flutter/tflite_flutter.dart';

Interpreter? _interp;

Future<bool> initInference(String assetPath) async {
  try {
    _interp = await Interpreter.fromAsset(assetPath);
    return true;
  } catch (_) {
    return false;
  }
}

Future<double> runInference(List<List<double>> window) async {
  final interp = _interp;
  if (interp == null) throw StateError('inference not initialised');
  final input = [window];
  final output = List.filled(1, 0.0).reshape([1, 1]);
  interp.run(input, output);
  return (output[0][0] as num).clamp(0.0, 1.0).toDouble();
}
