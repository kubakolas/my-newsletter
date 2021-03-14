class Subscription {
  int id;
  int shopId;
  int userId;

  Subscription({this.id, this.shopId, this.userId});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
        id: json['id'],
        shopId: json['shopId'],
        userId: json['userId']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'shopId': shopId
      };
}