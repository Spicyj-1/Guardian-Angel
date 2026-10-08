// Web stub: no on-device TFLite on web. Prototype drives simulated flow.
Future<bool> initInference(String assetPath) async => false;
Future<double> runInference(List<List<double>> window) async =>
    throw UnimplementedError('on-device inference is mobile-only');
