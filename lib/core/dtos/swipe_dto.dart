class SwipeDto {
  final String targetUserId;
  final SwipeType type;

  SwipeDto({
    required this.targetUserId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetUserId': targetUserId,
      'type': type.name
    };
  }
}
enum SwipeType { LEFT, RIGHT }
