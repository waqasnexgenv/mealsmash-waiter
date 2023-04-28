// To parse this JSON data, do
//
//     final sCart = sCartFromJson(jsonString);

import 'dart:convert';

SCart sCartFromJson(String str) => SCart.fromJson(json.decode(str));

String sCartToJson(SCart data) => json.encode(data.toJson());

class SCart {
  SCart({
    this.cartData,
    this.storeName,
    this.subtotal,
    this.discount,
    this.tax,
    this.total,
    // this.coupon,
  });

  List<CartDatumm>? cartData;
  String? storeName;
  int? subtotal;
  int? discount;
  double? tax;
  double? total;

  // List<dynamic>? coupon;

  factory SCart.fromJson(Map<String, dynamic> json) => SCart(
        cartData: List<CartDatumm>.from(
            json["cart_data"].map((x) => CartDatumm.fromJson(x))),
        storeName: json["store_name"],
        subtotal: json["subtotal"],
        discount: json["discount"],
        tax: json["tax"].toDouble(),
        total: json["total"].toDouble(),
        // coupon: List<dynamic>.from(json["coupon"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cart_data": List<dynamic>.from(cartData!.map((x) => x.toJson())),
        "store_name": storeName,
        "subtotal": subtotal,
        "discount": discount,
        "tax": tax,
        "total": total,
        // "coupon": List<dynamic>.from(coupon!.map((x) => x)),
      };
}

class CartDatumm {
  CartDatumm({
    this.id,
    this.itemId,
    this.squareCartId,
    this.name,
    this.image,
    this.price,
    this.priceType,
    this.defaultTaxRates,
    this.quantity,
    this.tax,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.squareCarItemModifiers,
  });

  int? id;
  String? itemId;
  int? squareCartId;
  String? name;
  String? image;
  int? price;
  dynamic priceType;
  int? defaultTaxRates;
  int? quantity;
  int? tax;
  String? currency;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? total;
  List<SquareCarItemModifier>? squareCarItemModifiers;

  factory CartDatumm.fromJson(Map<String, dynamic> json) => CartDatumm(
        id: json["id"],
        itemId: json["item_id"],
        squareCartId: json["square_cart_id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        priceType: json["priceType"],
        defaultTaxRates: json["defaultTaxRates"],
        quantity: json["quantity"],
        tax: json["tax"],
        currency: json["currency"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        total: json["total"],
        squareCarItemModifiers: List<SquareCarItemModifier>.from(
            json["square_car_item_modifiers"]
                .map((x) => SquareCarItemModifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "square_cart_id": squareCartId,
        "name": name,
        "image": image,
        "price": price,
        "priceType": priceType,
        "defaultTaxRates": defaultTaxRates,
        "quantity": quantity,
        "tax": tax,
        "currency": currency,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total": total,
        "square_car_item_modifiers":
            List<dynamic>.from(squareCarItemModifiers!.map((x) => x.toJson())),
      };
}

class SquareCarItemModifier {
  SquareCarItemModifier({
    this.id,
    this.squareCartItemId,
    this.modifierId,
    this.name,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? squareCartItemId;
  String? modifierId;
  String? name;
  int? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SquareCarItemModifier.fromJson(Map<String, dynamic> json) =>
      SquareCarItemModifier(
        id: json["id"],
        squareCartItemId: json["square_cart_item_id"],
        modifierId: json["modifier_id"],
        name: json["name"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "square_cart_item_id": squareCartItemId,
        "modifier_id": modifierId,
        "name": name,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
