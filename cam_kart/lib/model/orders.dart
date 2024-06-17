import 'dart:convert';

Orders orderFromJson(String str) => Orders.fromJson(json.decode(str));

String orderToJson(Orders data) => json.encode(data.toJson());
enum OrderStatus {
  ready,
  completed,
  rejected,
  paymentPending,
  responsePending,
  accepted;

  String toJson() => name;
  static OrderStatus fromJson(String json) => values.byName(json);
}

class Orders {
  String restaurant_id;
  String user_id;
  List<String> items;
  int total;
  String? timeOfOrder;
  bool? category;

  OrderStatus Order_status;

  Orders(
      {required this.restaurant_id,
      required this.user_id,
      required this.items,
      required this.total,
      required this.Order_status});
  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
        restaurant_id: json['restaurant_id'].toString(),
        user_id: json['user_id'].toString(),
        items: json['items'],
        total: json['total'],
        Order_status: json['Order_status']);
  }
  Map<String, dynamic> toJson() => {
    "restaurant_id": restaurant_id,
    "user_id": user_id,
    "items": List<dynamic>.from(items.map((x) => x)),
    "total": total,
    "timeOfOrder": timeOfOrder,
    "Order_status": Order_status,
  };
}
