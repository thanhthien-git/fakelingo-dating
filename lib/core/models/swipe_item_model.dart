class SwipeItemModel {
  final List<String> imageUrls;
  final String name;
  final int age;
  final String description;
  final String? lookingFor;
  final String? bio;
  final BasicInfoModel? basicInfo;

  SwipeItemModel({
    required this.imageUrls,
    required this.name,
    required this.age,
    required this.description,
    this.lookingFor,
    this.bio,
    this.basicInfo,
  });
}

class BasicInfoModel {
  final int? distance;
  final int? height;
  final String? gender;
  final String? zodiac;

  BasicInfoModel({
     this.distance,
     this.height,
     this.gender,
     this.zodiac,
  });
}
