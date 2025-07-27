class FeedCondition {
  final String gender;
  final List<double> coordinates;
  final int maxDistance;
  final int ageMin;
  final int ageMax;

  FeedCondition({
    required this.gender,
    required this.coordinates,
    required this.maxDistance,
    required this.ageMin,
    required this.ageMax,
  });

  factory FeedCondition.fromUserJson(Map<String, dynamic> json) {
    return FeedCondition(
      gender: json['preferences']['gender'],
      coordinates: List<double>.from(json['location']['coordinates']),
      maxDistance: json['preferences']['max_distance'],
      ageMin: json['preferences']['ageRange']['min'],
      ageMax: json['preferences']['ageRange']['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition' : {
        'gender': gender,
        'location': {
          'coordinates': coordinates,
        },
        'preferences': {
          'max_distance': maxDistance,
          'ageRange': {
            'min': ageMin,
            'max': ageMax,
          },
        },
      }
    };
  }
}
