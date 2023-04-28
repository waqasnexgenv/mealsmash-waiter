import 'dart:convert';

import 'package:hungerz_ordering/model/restaurant.dart';

class LoginResponse {
  LoginResponse({
    this.status,
    this.token,
    this.message,
    this.data,
  });

  bool? status;
  String? token;
  String? message;
  Restaurant? data;

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    status: json["status"] == null ? null : json["status"],
    token: json["token"] == null ? null : json["token"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Restaurant.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status == null ? null : status,
    "token": token == null ? null : token,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toMap(),
  };
}