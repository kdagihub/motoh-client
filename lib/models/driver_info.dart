class DriverInfo {
  DriverInfo({
    required this.id,
    required this.fullName,
    required this.city,
    this.photo,
    required this.motorcyclePlate,
    this.isVerified = false,
    this.isOnline = true,
    this.latitude,
    this.longitude,
    this.defaultZone,
    this.distanceKm,
    this.phoneForContact,
  });

  final String id;
  final String fullName;
  final String city;
  final String? photo;
  final String motorcyclePlate;
  final bool isVerified;
  final bool isOnline;
  final double? latitude;
  final double? longitude;
  final String? defaultZone;
  final double? distanceKm;
  final String? phoneForContact;

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      photo: json['photo'] as String?,
      motorcyclePlate: json['motorcycle_plate'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      isOnline: json['is_online'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      defaultZone: json['default_zone'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      phoneForContact: json['phone'] as String? ?? json['phone_number'] as String?,
    );
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts[0];
      return s.isEmpty ? '?' : s.substring(0, 1).toUpperCase();
    }
    final a = parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts[parts.length - 1].isNotEmpty ? parts[parts.length - 1][0] : '';
    return ('$a$b').toUpperCase();
  }
}
