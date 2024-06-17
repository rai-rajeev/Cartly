import 'dart:convert';

DishInfo userFromJson(String str) => DishInfo.fromJson(json.decode(str));
String userToJson(DishInfo data) => json.encode(data.toJson());

class DishInfo {
  String id;
  String? restId;
  String? name;
  String? suggestedTime;
  String? category;
  int? price;
  String? pic;

  // SuggestedTime? suggestedTime;
  bool inStock;
  // String? pic;
  DishInfo(
      {required this.category,
      required this.suggestedTime,
      required this.id,
      this.restId,
      this.name,
      this.price,
      required this.inStock,
      this.pic});
  factory DishInfo.fromJson(Map<String, dynamic> json) {
    return DishInfo(
      category: json['category'],
      id: json['id'],
      restId: json['Rest_Id'].toString(),
      name: json['name'].toString(),
      // category: Category.fromJson(json['category']),
      price: json['price'] as int,
      suggestedTime: json['suggestedTime'],
      inStock: json['InStock'],
      pic: json['pic'] != null ? json["pic"] : null,
      // pic: json['pic']['data']['data']
    );
  }
  Map<String,dynamic> toJson()=>{
    "category":category,
    "id":id,
    "Rest_Id":restId,
    "name":name,
    "price":price,
    "suggestedTime":suggestedTime,
    "InStock":inStock,
    "pic":pic
  };
}
