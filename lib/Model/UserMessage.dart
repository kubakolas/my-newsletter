import 'Message.dart';

class UserMessage {
  int id;
  int messageId;
  int userId;
  bool isUnread;
  bool isFavourite;
  Message message;

  bool contains(String text) {
    String subject = message.subject;
    String shopName = message.shop.name;
    String fullName = shopName + " " + subject;
    return fullName.toLowerCase().contains(text);
  }

  UserMessage({this.id, this.messageId, this.userId, this.isUnread, this.isFavourite, this.message});

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
        id: json['id'],
        messageId: json['messageId'],
        userId: json['userId'],
        isUnread: json['isUnread'],
        isFavourite: json['isFavorite'],
        message: Message.fromJson(json['message']));
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'messageId': messageId,
        'userId': userId,
        'isUnread': isUnread,
        'isFavorite': isFavourite,
        'message': message.toJson(),
      };
}
