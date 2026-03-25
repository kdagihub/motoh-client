import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentPosition() async {
    final ok = await ensurePermission();
    if (!ok) return null;
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }

  String formatShort(Position? p) {
    if (p == null) return 'Position indisponible';
    return '${p.latitude.toStringAsFixed(4)}, ${p.longitude.toStringAsFixed(4)}';
  }
}
