// Guardian Angel — Phase 4: bundled emergency data.
// Ported from promivine training repo (clinic_finder.py): 12 Nigerian clinics
// + 15-country emergency numbers. Offline-first: bundled, no network needed.
// Online enhancements (Nominatim reverse-geocode, Overpass clinic lookup)
// layer on later; offline path never depends on them.
import 'dart:math' as math;

class Clinic {
  final String name;
  final double lat;
  final double lng;
  final String address;
  final String phone;
  final String emergencyContact;
  final String state;
  const Clinic({
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
    required this.phone,
    required this.emergencyContact,
    required this.state,
  });
}

const List<Clinic> nigerianClinics = [
  Clinic(name: 'Lagos University Teaching Hospital (LUTH)', lat: 6.5158, lng: 3.3612, address: 'Idi-Araba, Surulere, Lagos', phone: '+234 1 583 8000', emergencyContact: '+234 1 583 8001', state: 'Lagos'),
  Clinic(name: 'Reddington Hospital', lat: 6.4531, lng: 3.4068, address: '12 Idowu Martins Street, Victoria Island, Lagos', phone: '+234 1 271 2345', emergencyContact: '+234 1 271 2346', state: 'Lagos'),
  Clinic(name: 'St. Nicholas Hospital', lat: 6.4535, lng: 3.3980, address: '57 Campbell Street, Lagos Island, Lagos', phone: '+234 1 263 5145', emergencyContact: '+234 1 263 5146', state: 'Lagos'),
  Clinic(name: 'Eko Hospital', lat: 6.4315, lng: 3.4268, address: '31 Mobolaji Bank Anthony Way, Ikeja, Lagos', phone: '+234 1 291 4091', emergencyContact: '+234 1 291 4092', state: 'Lagos'),
  Clinic(name: 'Lagos State University Teaching Hospital (LASUTH)', lat: 6.5700, lng: 3.3760, address: 'Ikeja, Lagos', phone: '+234 1 773 0000', emergencyContact: '+234 1 773 0001', state: 'Lagos'),
  Clinic(name: 'National Hospital Abuja', lat: 9.0481, lng: 7.4767, address: 'Plot 132, Central District, Abuja', phone: '+234 9 523 9000', emergencyContact: '+234 9 523 9001', state: 'FCT'),
  Clinic(name: 'Garki Hospital Abuja', lat: 9.0400, lng: 7.4700, address: 'Garki Area 10, Abuja', phone: '+234 9 290 3333', emergencyContact: '+234 9 290 3334', state: 'FCT'),
  Clinic(name: 'University of Port Harcourt Teaching Hospital (UPTH)', lat: 4.8020, lng: 7.0060, address: 'Choba, Port Harcourt, Rivers State', phone: '+234 84 232 191', emergencyContact: '+234 84 232 192', state: 'Rivers'),
  Clinic(name: 'Braithwaite Memorial Specialist Hospital', lat: 4.7900, lng: 7.0250, address: 'Old GRA, Port Harcourt, Rivers State', phone: '+234 84 233 400', emergencyContact: '+234 84 233 401', state: 'Rivers'),
  Clinic(name: 'University College Hospital (UCH) Ibadan', lat: 7.3880, lng: 3.8960, address: 'Queen Elizabeth Road, Ibadan, Oyo State', phone: '+234 2 241 1768', emergencyContact: '+234 2 241 1769', state: 'Oyo'),
  Clinic(name: 'Aminu Kano Teaching Hospital', lat: 11.9960, lng: 8.5480, address: 'Zaria Road, Kano', phone: '+234 64 666 000', emergencyContact: '+234 64 666 001', state: 'Kano'),
  Clinic(name: 'University of Nigeria Teaching Hospital (UNTH)', lat: 6.4300, lng: 7.5100, address: 'Ituku-Ozalla, Enugu', phone: '+234 42 253 300', emergencyContact: '+234 42 253 301', state: 'Enugu'),
];

const Map<String, Map<String, String>> emergencyNumbers = {
  'Nigeria': {'ambulance': '112', 'police': '199', 'fire': '112', 'general': '112'},
  'United States': {'ambulance': '911', 'police': '911', 'fire': '911', 'general': '911'},
  'United Kingdom': {'ambulance': '999', 'police': '999', 'fire': '999', 'general': '112'},
  'Canada': {'ambulance': '911', 'police': '911', 'fire': '911', 'general': '911'},
  'Australia': {'ambulance': '000', 'police': '000', 'fire': '000', 'general': '000'},
  'South Africa': {'ambulance': '10177', 'police': '10111', 'fire': '10177', 'general': '112'},
  'India': {'ambulance': '102', 'police': '100', 'fire': '101', 'general': '112'},
  'Kenya': {'ambulance': '999', 'police': '999', 'fire': '999', 'general': '112'},
  'Ghana': {'ambulance': '193', 'police': '191', 'fire': '192', 'general': '112'},
  'Egypt': {'ambulance': '123', 'police': '122', 'fire': '180', 'general': '112'},
  'Brazil': {'ambulance': '192', 'police': '190', 'fire': '193', 'general': '112'},
  'France': {'ambulance': '15', 'police': '17', 'fire': '18', 'general': '112'},
  'Germany': {'ambulance': '112', 'police': '110', 'fire': '112', 'general': '112'},
  'Japan': {'ambulance': '119', 'police': '110', 'fire': '119', 'general': '119'},
  'China': {'ambulance': '120', 'police': '110', 'fire': '119', 'general': '120'},
  'Default': {'ambulance': '112', 'police': '112', 'fire': '112', 'general': '112'},
};

double _haversine(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  double toRad(double d) => d * math.pi / 180.0;
  final dLat = toRad(lat2 - lat1);
  final dLng = toRad(lng2 - lng1);
  final sLat = math.sin(dLat / 2);
  final sLng = math.sin(dLng / 2);
  final a = sLat * sLat +
      math.cos(toRad(lat1)) * math.cos(toRad(lat2)) * sLng * sLng;
  return r * 2 * math.asin(math.sqrt(a));
}

/// Nearest bundled clinic within [radiusKm], or null (caller falls back to
/// country emergency numbers — never a fake location, per Streamlit rule).
Clinic? nearestClinic(double lat, double lng, {double radiusKm = 5.0}) {
  Clinic? best;
  double bestD = radiusKm;
  for (final c in nigerianClinics) {
    final d = _haversine(lat, lng, c.lat, c.lng);
    if (d <= bestD) {
      bestD = d;
      best = c;
    }
  }
  return best;
}
