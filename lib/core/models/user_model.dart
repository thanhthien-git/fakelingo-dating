class User {
  final String id;
  final String email;
  final String userName;
  final String role;
  final DateTime createAt;
  final DateTime lastActive;
  final Profile? profile;

  User({
    required this.id,
    required this.email,
    required this.userName,
    required this.role,
    required this.createAt,
    required this.lastActive,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      userName: json['userName'],
      role: json['role'],
      createAt: DateTime.parse(json['createAt']),
      lastActive: DateTime.parse(json['lastActive']),
      profile: (json['profile'] != null && json['profile'].isNotEmpty)
          ? Profile.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'userName': userName,
    'role': role,
    'createAt': createAt.toIso8601String(),
    'lastActive': lastActive.toIso8601String(),
    'profile': profile?.toJson() ?? null,
  };
}

class Profile {
  final String name;
  final int age;
  final String gender;
  final String bio;
  final List<String> photos;
  final Location location;
  final List<String> interests;
  final Preferences preferences;

  Profile({
    required this.name,
    required this.age,
    required this.gender,
    required this.bio,
    required this.photos,
    required this.location,
    required this.interests,
    required this.preferences,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      photos: List<String>.from(json['photos']),
      location: Location.fromJson(json['location']),
      interests: List<String>.from(json['interests']),
      preferences: Preferences.fromJson(json['preferences']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'bio': bio,
    'photos': photos,
    'location': location.toJson(),
    'interests': interests,
    'preferences': preferences.toJson(),
  };
}

class Location {
  final List<double> coordinates;
  final String type;

  Location({
    required this.coordinates,
    required this.type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: List<double>.from(json['coordinates']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'coordinates': coordinates,
    'type': type,
  };
}

class Preferences {
  final AgeRange ageRange;
  final String gender;
  final int maxDistance;
  final String id;

  Preferences({
    required this.ageRange,
    required this.gender,
    required this.maxDistance,
    required this.id,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      ageRange: AgeRange.fromJson(json['ageRange']),
      gender: json['gender'],
      maxDistance: json['max_distance'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ageRange': ageRange.toJson(),
    'gender': gender,
    'max_distance': maxDistance,
    '_id': id,
  };
}

class AgeRange {
  final int min;
  final int max;

  AgeRange({
    required this.min,
    required this.max,
  });

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
