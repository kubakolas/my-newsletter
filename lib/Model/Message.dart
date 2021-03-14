import 'package:mynewsletter/Model/Shop.dart';

class Message {
  final int id;
  final int shopId;
  final String subject;
  final String data;
  final DateTime date;
  final Shop shop;

  Message(
      {this.id,
      this.shopId,
      this.subject,
      this.data,
        this.date,
      this.shop});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        shopId: json['shopId'],
        subject: json['subject'],
        data: json['data'],
        date: DateTime.parse(json['date'].toString()),
        shop: Shop.fromJson(json['shop']));
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'shopId': shopId,
        'subject': subject,
        'data': data,
        'date': date.toIso8601String(),
        'shop': shop.toJson()
      };
}
