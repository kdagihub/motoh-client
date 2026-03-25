import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../models/driver_info.dart';
import '../services/location_service.dart';

class DriversProvider extends ChangeNotifier {
  DriversProvider() {
    _mockDrivers = _buildMockDrivers();
  }

  late final List<DriverInfo> _mockDrivers;
  Position? _lastPosition;
  bool _locating = false;

  List<DriverInfo> get nearbyPreviewDrivers => List.unmodifiable(_mockDrivers);
  Position? get lastPosition => _lastPosition;
  bool get locating => _locating;

  static List<DriverInfo> _buildMockDrivers() {
    return [
      DriverInfo(
        id: 'mock-1',
        fullName: 'Kouassi Yao',
        city: 'Abidjan',
        motorcyclePlate: 'AB-4521-CI',
        isVerified: true,
        isOnline: true,
        defaultZone: 'Cocody',
        distanceKm: 0.8,
        latitude: 5.36,
        longitude: -4.01,
        phoneForContact: '+2250712345678',
      ),
      DriverInfo(
        id: 'mock-2',
        fullName: 'Traoré Ibrahim',
        city: 'Abidjan',
        motorcyclePlate: 'AB-8890-CI',
        isVerified: false,
        isOnline: true,
        defaultZone: 'Marcory',
        distanceKm: 1.4,
        latitude: 5.28,
        longitude: -4.01,
        phoneForContact: '+2250798765432',
      ),
      DriverInfo(
        id: 'mock-3',
        fullName: 'Koné Aminata',
        city: 'Abidjan',
        motorcyclePlate: 'AB-1203-CI',
        isVerified: true,
        isOnline: false,
        defaultZone: 'Yopougon',
        distanceKm: 2.1,
        latitude: 5.33,
        longitude: -4.08,
        phoneForContact: '+2250501020304',
      ),
      DriverInfo(
        id: 'mock-4',
        fullName: 'Ouattara Serge',
        city: 'Abidjan',
        motorcyclePlate: 'AB-3344-CI',
        isVerified: true,
        isOnline: true,
        defaultZone: 'Plateau',
        distanceKm: 3.0,
        latitude: 5.32,
        longitude: -4.02,
        phoneForContact: '+2250788899001',
      ),
    ];
  }

  Future<void> refreshLocation(LocationService locationService) async {
    _locating = true;
    notifyListeners();
    try {
      _lastPosition = await locationService.getCurrentPosition();
    } finally {
      _locating = false;
      notifyListeners();
    }
  }
}
