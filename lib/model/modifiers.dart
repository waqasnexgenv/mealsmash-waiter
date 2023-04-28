// To parse this JSON data, do
//
//     final modifier = modifierFromJson(jsonString);

import 'dart:convert';

Modifier modifierFromJson(String str) => Modifier.fromJson(json.decode(str));

String modifierToJson(Modifier data) => json.encode(data.toJson());

class Modifier {
  Modifier({
    this.success,
    this.modifiers,
  });

  bool? success;
  List<ModifierElement>? modifiers;

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
        success: json["success"],
        modifiers: List<ModifierElement>.from(
            json["modifiers"].map((x) => ModifierElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "modifiers": List<dynamic>.from(modifiers!.map((x) => x.toJson())),
      };
}

class ModifierElement {
  ModifierElement({
    this.id,
    this.name,
    this.price = '',
    this.currency,
  });

  String? id;
  String? name;
  String price;
  String? currency;

  factory ModifierElement.fromJson(Map<String, dynamic> json) =>
      ModifierElement(
        id: json["id"].toString(),
        name: json["name"],
        price: json["price"].toString(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };
}
