import 'dart:convert';

RestInfo restInfoFromJson(String str) => RestInfo.fromJson(json.decode(str));

String restInfoToJson(RestInfo data) => json.encode(data.toJson());
class RazorpayCred{
  String key_id="";
  String keySecret="";
  RazorpayCred( {required this.key_id,required this.keySecret});
  factory RazorpayCred.fromJson(Map<String,dynamic> json) =>
      RazorpayCred(
          key_id: json["key_id"],
          keySecret: json["keySecret"]);
  Map<String,dynamic> toJson()=>{
    "key_id":key_id,
    "keySecret":keySecret
  };
}
class RestInfo {
  RestInfo({
    required this.id,
    required this.ownerName,
    required this.restaurantName,
    required this.phoneNumber,
    required this.email,
    this.menu,
    required this.location,
    required this.status,
    this.pic,
    required this.razorpayCred,
    required this.closingTime,
    required this.openingTime,

  });

  String id;
  String ownerName;
  String restaurantName;
  String phoneNumber;
  String email;
  List<String>? menu;
  String location;
  String status;
  String? pic;
  String openingTime;
  String closingTime;
  RazorpayCred razorpayCred=RazorpayCred(key_id: '', keySecret:'');
  factory RestInfo.fromJson(Map<String, dynamic> json) => RestInfo(
    id: json["id"],
    ownerName: json["ownerName"],
    restaurantName: json["restaurantName"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    menu: json['menu'] ==null? <String>[]:List<String>.from( json['menu']!.map((x)=>x)),
    location: json["location"],
    status: json["status"],
    pic: json['pic'] != null ?json["pic"]:null,
    razorpayCred:json['razorpayCred']!=null? RazorpayCred.fromJson(json['razorpayCred']):RazorpayCred( key_id: '', keySecret: ''),
    closingTime: json['closingTime'],
    openingTime: json['openingTime'],


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ownerName": ownerName,
    "restaurantName": restaurantName,
    "phoneNumber": phoneNumber,
    "email": email,
    "menu":menu ?? <String>[],
    "razorpayCred":razorpayCred.toJson(),
    "location": location,
    "status": status,
    "openingTime":openingTime,
    "closingTime":closingTime

  };
}
