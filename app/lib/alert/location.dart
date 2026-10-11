// Guardian Angel — location: live GPS with preset-address fallback (PRD 5.2).
// Rule inherited from Streamlit: never a fake location. If neither GPS nor
// a saved address exists, location is reported as unknown and the alert
// still goes out (a missing coordinate must never block a cry for help).
class AppLocation {
  final double? lat;
  final double? lng;
  final String method; // 'GPS' | 'Preset address' | 'Unknown'
  const AppLocation({this.lat, this.lng, required this.method});
  bool get hasCoords => lat != null && lng != null;
  String get mapsLink =>
      hasCoords ? 'https://www.google.com/maps?q=$lat,$lng' : 'no coordinates';
}

/// GPS provider behind an interface: real geolocator on mobile, stub on web.
abstract class GpsProvider {
  Future<AppLocation> current();
}

/// Fallback address the patient saves in settings (used when GPS denied).
class PresetAddress {
  double? lat;
  double? lng;
  String label;
  PresetAddress({this.lat, this.lng, this.label = ''});
  bool get set => lat != null && lng != null;
}

/// Resolution order: GPS → preset → unknown. Mirrors clinic_finder levels.
Future<AppLocation> resolveLocation(
    GpsProvider gps, PresetAddress preset) async {
  try {
    final g = await gps.current();
    if (g.hasCoords) return g;
  } catch (_) {
    // GPS denied/unavailable — fall through, never crash the alert path.
  }
  if (preset.set) {
    return AppLocation(
        lat: preset.lat, lng: preset.lng, method: 'Preset address');
  }
  return const AppLocation(method: 'Unknown');
}
