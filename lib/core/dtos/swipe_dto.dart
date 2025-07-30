class SwipeDto {
  final String targetUserId;
  final String type;

  SwipeDto({
    required this.targetUserId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetUserId': targetUserId,
      'type': type
    };
  }
}
