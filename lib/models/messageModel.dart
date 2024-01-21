class MessageModel {
  String senderID;
  String reciverID;
  String message;
  DateTime timestamp; // Add timestamp property

  MessageModel({
    required this.senderID,
    required this.reciverID,
    required this.message,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map map) {
    return MessageModel(
      senderID: map['senderID'],
      reciverID: map['reciverID'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']), // Parse timestamp from String
    );
  }

  Map toJson() {
    return {
      'senderID': senderID,
      'reciverID': reciverID,
      'message': message,
      'timestamp': timestamp.toIso8601String(), // Convert timestamp to String
    };
  }
}
