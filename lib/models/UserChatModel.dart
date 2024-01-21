class ChatUserModel {
  String? userId;
  String username;
  String lastMessage;
  DateTime timestamp;

  ChatUserModel({
    required this.userId,
    required this.username,
    required this.lastMessage,
    required this.timestamp,});
}