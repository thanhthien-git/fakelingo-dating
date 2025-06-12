class SendMessageModel {
  final String fromUsername;
  final String fromUserId;
  final String toUserName;
  final String toUserId;
  final String content;

  SendMessageModel({
    required this.fromUsername,
    required this.fromUserId,
    required this.toUserName,
    required this.toUserId,
    required this.content,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      fromUsername: json['fromUsername'],
      fromUserId: json['fromUserId'],
      toUserName: json['toUserName'],
      toUserId: json['toUserId'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUsername': fromUsername,
      'fromUserId': fromUserId,
      'toUserName': toUserName,
      'toUserId': toUserId,
      'content': content,
    };
  }
}
