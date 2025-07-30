class User {
  final String id;
  final String? email;
  final String? userName;
  final String? role;
  final DateTime? createAt;
  final DateTime? lastActive;
  final Profile? profile;

  User({
    required this.id,
    this.email,
    this.userName,
    this.role,
    this.createAt,
    this.lastActive,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'],
      userName: json['userName'],
      role: json['role'],
      createAt: json['createAt'] != null ? DateTime.tryParse(json['createAt']) : null,
      lastActive: json['lastActive'] != null ? DateTime.tryParse(json['lastActive']) : null,
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'userName': userName,
    'role': role,
    'createAt': createAt?.toIso8601String(),
    'lastActive': lastActive?.toIso8601String(),
    'profile': profile?.toJson(),
  };
}

class Profile {
  final String? name;
  final int? age;
  final String? gender;
  final String? bio;
  final List<String> photos;
  final Location? location;
  final List<String> interests;
  final Preferences? preferences;

  Profile({
    this.name,
    this.age,
    this.gender,
    this.bio,
    required this.photos,
    this.location,
    required this.interests,
    this.preferences,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      interests: (json['interests'] ?? json['interest'] ?? [])
          .map<String>((e) => e.toString())
          .toList(),
      preferences: json['preferences'] != null ? Preferences.fromJson(json['preferences']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'bio': bio,
    'photos': photos,
    'location': location?.toJson(),
    'interests': interests,
    'preferences': preferences?.toJson(),
  };
}

class Location {
  final List<double> coordinates;
  final String? type;

  Location({required this.coordinates, this.type});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'coordinates': coordinates,
    'type': type,
  };
}

class Preferences {
  final AgeRange? ageRange;
  final String? gender;
  final int? maxDistance;
  final String? id;

  Preferences({this.ageRange, this.gender, this.maxDistance, this.id});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      ageRange: json['ageRange'] != null ? AgeRange.fromJson(json['ageRange']) : null,
      gender: json['gender'],
      maxDistance: json['max_distance'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ageRange': ageRange?.toJson(),
    'gender': gender,
    'max_distance': maxDistance,
    '_id': id,
  };
}

class AgeRange {
  final int? min;
  final int? max;

  AgeRange({this.min, this.max});

  factory AgeRange.fromJson(Map<String, dynamic> json) {
    return AgeRange(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() => {
    'min': min,
    'max': max,
  };
}
