
import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.items,
    required this.total,
    required this.timeOfOrder,
    required this.orderStatus,
     required this.paymentId,
  });

  String id;
  String restaurantId;
  String userId;
  List<String> items;
  int total;
  String timeOfOrder;
  String orderStatus;
  String paymentId='';
  // String v;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    userId: json["user_id"],
    items: List<String>.from(json["items"].map((x) => (x))),
    total: json["total"] as int,
    timeOfOrder: json["timeOfOrder"],
    orderStatus: json["Order_status"],
    paymentId: json['paymentId'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "user_id": userId,
    "items": List<dynamic>.from(items.map((x) => x)),
    "total": total,
    "timeOfOrder": timeOfOrder,
    "Order_status": orderStatus,
    'paymentId':paymentId,
  };
}
