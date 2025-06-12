class ChatUser {
  final String id;
  final String username;
  final String? avatar;

  ChatUser({required this.id, required this.username, this.avatar});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    final List<dynamic>? photos = profile?['photos'];
    final String? avatar = (photos != null && photos.isNotEmpty) ? photos.first : null;

    return ChatUser(
      id: json['_id'] ?? '',
      username: json['userName'] ?? '',
      avatar: avatar ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'username': username,
    'avatar': avatar,
  };
}

class ChatList {
  final ChatUser user;
  final String conversationId;
  final String lastMessage;

  ChatList({
    required this.user,
    required this.conversationId,
    required this.lastMessage,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      user: ChatUser.fromJson(json['user']),
      conversationId: json['conversationId'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'conversationId': conversationId,
    'lastMessage': lastMessage,
  };
}
