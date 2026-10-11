// Mobile GPS via geolocator (permission requested on first use).
import 'package:geolocator/geolocator.dart';
import 'location.dart';

class MobileGpsProvider implements GpsProvider {
  @override
  Future<AppLocation> current() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return const AppLocation(method: 'Unknown');
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
    return AppLocation(lat: pos.latitude, lng: pos.longitude, method: 'GPS');
  }
}
