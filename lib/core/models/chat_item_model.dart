class ChatUser {
  final String id;
  final String username;
  final String? avatar;
  final String displayName;

  ChatUser({required this.id, required this.username, this.avatar,required this.displayName});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    final List<dynamic>? photos = profile?['photos'];
    final String? avatar = (photos != null && photos.isNotEmpty) && photos.first != null
        ? photos.first as String
        : null;
    final String displayName = profile?['name'] ?? json['userName'] ?? '';

    return ChatUser(
      id: json['_id'] ?? '',
      username: json['userName'] ?? '',
      avatar: avatar ?? '',
      displayName: displayName,
    );
  }


  Map<String, dynamic> toJson() => {
    '_id': id,
    'username': username,
    'avatar': avatar,
    'displayName': displayName
  };
}

class ChatList {
  ChatUser user;
  String conversationId;
  String? lastMessageId;
  String? lastMessageContent;

  ChatList({
    required this.user,
    required this.conversationId,
    this.lastMessageId,
    this.lastMessageContent,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      user: ChatUser.fromJson(json['user']),
      conversationId: json['conversationId'],
      lastMessageId: json['lastMessageId'],
      lastMessageContent: json['lastMessageContent'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'conversationId': conversationId,
    'lastMessageId': lastMessageId,
    'lastMessageContent': lastMessageContent,
  };
}
