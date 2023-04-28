// To parse this JSON data, do
//
//     final squareData = squareDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

SquareData squareDataFromJson(String str) =>
    SquareData.fromJson(json.decode(str));

String squareDataToJson(SquareData data) => json.encode(data.toJson());

class SquareData {
  SquareData({
    this.success,
    this.platform_configured,
    this.scategories,
  });

  bool? success;
  String? platform_configured;
  List<SCategory>? scategories;

  factory SquareData.fromJson(Map<String, dynamic> json) => SquareData(
        success: json["success"],
        platform_configured: json["platform_configured"],
        scategories: List<SCategory>.from(
            json["categories"].map((x) => SCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "platform_configured": platform_configured,
        "categories": List<dynamic>.from(scategories!.map((x) => x.toJson())),
      };
}

class SCategory {
  SCategory({
    this.id,
    this.name,
    this.squareProducts,
  });

  String? id;
  String? name;
  List<SquareProduct>? squareProducts;

  factory SCategory.fromJson(Map<String, dynamic> json) => SCategory(
        id: json["id"],
        name: json["name"],
        squareProducts: List<SquareProduct>.from(
            json["products"].map((x) => SquareProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "products": List<dynamic>.from(squareProducts!.map((x) => x.toJson())),
      };
}

class SquareProduct {
  SquareProduct({
    this.id,
    this.title,
    this.count,
    this.picture,
    this.price,
    this.squarevariants,
  });

  String? id;
  String? title;
  int? count;

  String? picture;
  PriceClass? price;
  List<SquareVariant>? squarevariants;
  bool? isSelected = false;

  factory SquareProduct.fromJson(Map<String, dynamic> json) => SquareProduct(
        id: json["id"],
        title: json["title"],
        picture: json["picture"],
        count: json["count"],
        price: PriceClass.fromJson(json["price"]),
        squarevariants: List<SquareVariant>.from(
            json["variants"].map((x) => SquareVariant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "picture": picture,
        "count": count,
        "price": price?.toJson(),
        "variants": List<dynamic>.from(squarevariants!.map((x) => x.toJson())),
      };
}

class PriceClass {
  PriceClass({
    this.price,
    // this.currency,
  });

  String? price;

  // Currency currency;

  factory PriceClass.fromJson(Map<String, dynamic> json) => PriceClass(
        price: json["price"].toString(),
        // currency:json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        // "currency": currency,
      };
}

class SquareVariant {
  SquareVariant({
    this.id,
    this.title,
    this.price,
    this.currency,
  });

  String? id;
  String? title;
  double? price;
  String? currency;

  factory SquareVariant.fromJson(Map<String, dynamic> json) => SquareVariant(
        id: json["id"],
        title: json["title"],
        price: json["price"].toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "currency": currency,
      };
}
