import 'package:fakelingo/core/models/user_model.dart';

class SwipeItemModel {
  final List<String> imageUrls;
  final String name;
  final int age;
  final String gender;
  final String? bio;
  final String? description;
  final String? lookingFor;
  final String userId;
  final int? distance;

  SwipeItemModel({
    required this.imageUrls,
    required this.name,
    required this.age,
    required this.gender,
    this.bio,
    this.description,
    this.lookingFor,
    required this.userId,
    this.distance,
  });

  factory SwipeItemModel.fromUser(User user) {
    final profile = user.profile!;
    return SwipeItemModel(
      imageUrls: profile.photos,
      name: profile.name,
      age: profile.age,
      gender: profile.gender,
      bio: profile.bio,
      description: profile.bio,
      userId: user.id,
      lookingFor: null,
      distance: profile.preferences.maxDistance,
    );
  }
}
