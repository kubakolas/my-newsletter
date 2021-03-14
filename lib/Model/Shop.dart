class Shop {
  final int id;
  final String name;
  final String email;

  Shop({this.id, this.name, this.email});

  factory Shop.fromJson(Map<String, dynamic> json, {isFavourite, isRead}) {
    return Shop(
        id: json['id'],
        name: json['name'],
        email: json['email']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'email': email
      };
}