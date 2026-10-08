// Conditional inference backend: mobile (TFLite w/ select_tf_ops) vs web stub.
export 'inference_stub.dart' if (dart.library.io) 'inference_io.dart';
