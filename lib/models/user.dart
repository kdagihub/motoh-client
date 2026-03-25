class ClientProfile {
  ClientProfile({this.fullName});

  final String? fullName;

  factory ClientProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ClientProfile();
    return ClientProfile(
      fullName: json['full_name'] as String? ?? json['fullName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'full_name': fullName};

  ClientProfile copyWith({String? fullName}) {
    return ClientProfile(fullName: fullName ?? this.fullName);
  }
}

class User {
  User({
    required this.id,
    this.phone,
    this.clientProfile,
  });

  final String id;
  final String? phone;
  final ClientProfile? clientProfile;

  String get displayName {
    final n = clientProfile?.fullName?.trim();
    if (n != null && n.isNotEmpty) return n;
    return 'Vous';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? profileMap;
    final cp = json['client_profile'] ?? json['clientProfile'];
    if (cp is Map<String, dynamic>) {
      profileMap = cp;
    }
    return User(
      id: json['id'] as String? ?? json['user_id'] as String? ?? '',
      phone: json['phone'] as String?,
      clientProfile: ClientProfile.fromJson(profileMap),
    );
  }

  User copyWith({ClientProfile? clientProfile, String? phone}) {
    return User(
      id: id,
      phone: phone ?? this.phone,
      clientProfile: clientProfile ?? this.clientProfile,
    );
  }
}
