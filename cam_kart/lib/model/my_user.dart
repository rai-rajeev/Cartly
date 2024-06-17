import 'dart:convert';

import 'package:flutter/material.dart';
MyUser userFromJson(String str) => MyUser.fromJson(json.decode(str));
String userToJson(MyUser data) => json.encode(data.toJson());
class MyUser extends ChangeNotifier {
  final String uid;
  final String? email;
  final String? fullName;
  String? mobile;
  final String? profile;
  String? apiKey;

  void setApiKey(String tkn) {
    this.apiKey = tkn;

    notifyListeners();
  }

  MyUser(
      {required this.email,
        required this.apiKey,
        required this.fullName,
        required this.mobile,
        required this.profile,
        required this.uid});
  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
    uid: json["uid"],
    fullName: json["fullName"],
    profile: json["profile"],
    mobile: json["mobile"],
    apiKey: json['api_key'],
    email: json['email']
  );
  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fullName": fullName,
    "profile": profile,
    "mobile": mobile,
    "api_key": apiKey,
    "email": email,
  };
}