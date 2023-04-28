import 'dart:convert';

class CartResponse {
  CartResponse({
    this.status,
    this.cartData,
    this.storeName,
    this.subtotal,
    this.discount,
    this.tax,
    this.total,
    this.coupon,
  });

  bool? status;
  List<CartItem>? cartData;
  String? storeName;
  double? subtotal;
  double? discount;
  double? tax;
  double? total;
  dynamic coupon;

  factory CartResponse.fromJson(String str) =>
      CartResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartResponse.fromMap(Map<String, dynamic> json) => CartResponse(
    status: json["status"],
    cartData: List<CartItem>.from(
        json["cart_data"].map((x) => CartItem.fromMap(x))),
    storeName: json["store_name"],
    subtotal: double.parse(json["subtotal"].toString()),
    discount: double.parse(json["discount"].toString()),
    tax: double.parse(json["tax"].toString()),
    total: double.parse(json["total"].toString()),
    coupon: json["coupon"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "cart_data": List<dynamic>.from(cartData!.map((x) => x.toMap())),
    "store_name": storeName,
    "subtotal": subtotal,
    "discount": discount,
    "tax": tax,
    "total": total,
    "coupon": coupon,
  };
}

class CartItem {
  CartItem({
    this.id,
    this.productId,
    this.mobileCartId,
    this.qty,
    this.extras,
    this.variantPrice,
    this.variantId,
    this.variantName,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.total,
    this.picture,
    this.description,
    this.price,
    this.extraPriceTotalAll,
    this.cartItemExtras,
    this.term,
    this.cartItemExtrasTotal,
  });

  int? id;
  int? productId;
  int? mobileCartId;
  String? qty;
  String? extras;
  String? variantPrice;
  int? variantId;
  String? variantName;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  double? total;
  String? picture;
  String? description;
  String? price;
  int? extraPriceTotalAll;
  List<CartItemExtra>? cartItemExtras;
  Term? term;
  List<CartItemExtrasTotal>? cartItemExtrasTotal;

  factory CartItem.fromJson(String str) => CartItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    productId: json["product_id"],
    mobileCartId: json["mobile_cart_id"],
    qty: json["qty"],
    extras: json["extras"] == null ? null : json["extras"],
    variantPrice:
    json["variant_price"] == null ? null : json["variant_price"],
    variantId: json["variant_id"] == null ? null : json["variant_id"],
    variantName: json["variant_name"] == null ? null : json["variant_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    title: json["title"],
    total:double.parse(json["total"].toString()) ,
    picture: json["picture"],
    description: json["description"],
    price: json["price"],
    extraPriceTotalAll: json["extra_price_total_all"],
    cartItemExtras: List<CartItemExtra>.from(
        json["cart_item_extras"].map((x) => CartItemExtra.fromMap(x))),
    term: Term.fromMap(json["term"]),
    cartItemExtrasTotal: List<CartItemExtrasTotal>.from(
        json["cart_item_extras_total"]
            .map((x) => CartItemExtrasTotal.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "product_id": productId,
    "mobile_cart_id": mobileCartId,
    "qty": qty,
    "extras": extras == null ? null : extras,
    "variant_price": variantPrice == null ? null : variantPrice,
    "variant_id": variantId == null ? null : variantId,
    "variant_name": variantName == null ? null : variantName,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "title": title,
    "total": total,
    "picture": picture,
    "description": description,
    "price": price,
    "extra_price_total_all": extraPriceTotalAll,
    "cart_item_extras":
    List<dynamic>.from(cartItemExtras!.map((x) => x.toMap())),
    "term": term!.toMap(),
    "cart_item_extras_total":
    List<dynamic>.from(cartItemExtrasTotal!.map((x) => x.toMap())),
  };

  removeAt(dynamic i) {}
}

class CartItemExtra {
  CartItemExtra({
    this.id,
    this.extraName,
    this.extraPrice,
    this.mobileCartItemId,
  });

  int? id;
  String? extraName;
  String? extraPrice;
  int? mobileCartItemId;

  factory CartItemExtra.fromJson(String str) =>
      CartItemExtra.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItemExtra.fromMap(Map<String, dynamic> json) => CartItemExtra(
    id: json["id"],
    extraName: json["extra_name"],
    extraPrice: json["extra_price"],
    mobileCartItemId: json["mobile_cart_item_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "extra_name": extraName,
    "extra_price": extraPrice,
    "mobile_cart_item_id": mobileCartItemId,
  };
}

class CartItemExtrasTotal {
  CartItemExtrasTotal({
    this.mobileCartItemId,
    this.extraPriceTotal,
  });

  int? mobileCartItemId;
  int? extraPriceTotal;

  factory CartItemExtrasTotal.fromJson(String str) =>
      CartItemExtrasTotal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItemExtrasTotal.fromMap(Map<String, dynamic> json) =>
      CartItemExtrasTotal(
        mobileCartItemId: json["mobile_cart_item_id"],
        extraPriceTotal: json["extra_price_total"],
      );

  Map<String, dynamic> toMap() => {
    "mobile_cart_item_id": mobileCartItemId,
    "extra_price_total": extraPriceTotal,
  };
}

class Term {
  Term({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.lang,
    this.authId,
    this.mainCatId,
    this.departmentId,
    this.unitId,
    this.status,
    this.type,
    this.count,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.discountedPrice,
    this.url,
    this.picture,
    this.price,
    this.preview,
    this.excerpt,
    this.discountMeta,
  });

  int? id;
  String? title;
  String? slug;
  String? description;
  String? lang;
  int? authId;
  dynamic mainCatId;
  int? departmentId;
  int? unitId;
  int? status;
  int? type;
  int? count;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? total;
  double? discountedPrice;
  String? url;
  String? picture;
  Price? price;
  Excerpt? preview;
  Excerpt? excerpt;
  dynamic discountMeta;

  factory Term.fromJson(String str) => Term.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Term.fromMap(Map<String, dynamic> json) => Term(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    description: json["description"],
    lang: json["lang"],
    authId: json["auth_id"],
    mainCatId: json["main_cat_id"],
    departmentId: json["department_id"],
    unitId: json["unit_id"],
    status: json["status"],
    type: json["type"],
    count: json["count"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    total: double.parse(json["total"].toString()),
    discountedPrice:double.parse( json["discounted_price"].toString()),
    url: json["url"],
    picture: json["picture"],
    price: Price.fromMap(json["price"]),
    preview: Excerpt.fromMap(json["preview"]),
    excerpt: Excerpt.fromMap(json["excerpt"]),
    discountMeta: json["discount_meta"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "slug": slug,
    "description": description,
    "lang": lang,
    "auth_id": authId,
    "main_cat_id": mainCatId,
    "department_id": departmentId,
    "unit_id": unitId,
    "status": status,
    "type": type,
    "count": count,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "total": total,
    "discounted_price": discountedPrice,
    "url": url,
    "picture": picture,
    "price": price!.toMap(),
    "preview": preview!.toMap(),
    "excerpt": excerpt!.toMap(),
    "discount_meta": discountMeta,
  };
}

class Excerpt {
  Excerpt({
    this.id,
    this.termId,
    this.type,
    this.content,
    this.image,
  });

  int? id;
  int? termId;
  String? type;
  String? content;
  String? image;

  factory Excerpt.fromJson(String str) => Excerpt.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Excerpt.fromMap(Map<String, dynamic> json) => Excerpt(
    id: json["id"],
    termId: json["term_id"],
    type: json["type"],
    content: json["content"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "term_id": termId,
    "type": type,
    "content": content,
    "image": image == null ? null : image,
  };
}

class Price {
  Price({
    this.id,
    this.termId,
    this.price,
    this.quantity,
    this.minimumThreshold,
    this.enableThreshold,
  });

  int? id;
  int? termId;
  String? price;
  int? quantity;
  String? minimumThreshold;
  String? enableThreshold;

  factory Price.fromJson(String str) => Price.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Price.fromMap(Map<String, dynamic> json) => Price(
    id: json["id"] == null ? null : json["id"],
    termId: json["term_id"] == null ? null : json["term_id"],
    price: json["price"] == null ? null : json["price"].toString(),
    quantity: json["quantity"] == null ? null : json["quantity"],
    minimumThreshold: json["product_minimum_threshold"] == null ? null : json["product_minimum_threshold"],
    enableThreshold: json["enable_threshold_alert"] == null ? null : json["enable_threshold_alert"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "term_id": termId == null ? null : termId,
    "price": price == null ? null : price,
    "quantity": quantity == null ? null : quantity,
    "product_minimum_threshold": minimumThreshold == null ? null : minimumThreshold,
    "enable_threshold_alert": enableThreshold == null ? null : enableThreshold,
  };
}