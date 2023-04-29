import 'dart:convert';

import 'package:Mealsmash_Waiter/model/restaurant.dart';

class PastOrder {
  PastOrder({
    this.id,
    this.userId,
    this.vendorId,
    this.riderId,
    this.riderTrigger,
    this.riderOrderCompleted,
    this.seen,
    this.orderType,
    this.reachIn,
    this.invId,
    this.tableId,
    this.tableName,
    this.areaName,
    this.seats,
    this.paymentMethod,
    this.paymentStatus,
    this.bulleyeToken,
    this.couponId,
    this.total,
    this.subtotal,
    this.tax,
    this.shipping,
    this.commission,
    this.discount,
    this.status,
    this.kStatus,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.vendorName,
    this.orderStatus,
    this.kitchenStatus,
    this.orderPaymentStatus,
    this.orderTypeStatus,
    this.date,
    this.time,
    this.item,
    this.vendor,
    this.rider,
    this.orderMeta,
  });

  int? id;
  int? userId;
  int? vendorId;
  dynamic riderId;
  int? riderTrigger;
  int? riderOrderCompleted;
  int? seen;
  String? orderType;
  dynamic reachIn;
  String? invId;
  int? tableId;
  String? tableName;
  String? areaName;
  String? seats;
  String? paymentMethod;
  String? paymentStatus;
  dynamic bulleyeToken;
  dynamic couponId;
  String? total;
  String? subtotal;
  String? tax;
  String? shipping;
  int? commission;
  String? discount;
  int? status;
  int? kStatus;
  String? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? vendorName;
  String? orderStatus;
  String? kitchenStatus;
  String? orderPaymentStatus;
  String? orderTypeStatus;
  String? date;
  String? time;
  int? item;
  Restaurant? vendor;
  dynamic rider;
  List<OrderMetaa>? orderMeta;

  factory PastOrder.fromJson(String str) => PastOrder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PastOrder.fromMap(Map<String, dynamic> json) => PastOrder(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    riderId: json["rider_id"],
    riderTrigger:
    json["rider_trigger"] == null ? null : json["rider_trigger"],
    riderOrderCompleted: json["rider_order_completed"] == null
        ? null
        : json["rider_order_completed"],
    seen: json["seen"] == null ? null : json["seen"],
    orderType:
    json["order_type"] == null ? null : json["order_type"].toString(),
    reachIn: json["reach_in"],
    invId: json["inv_id"] == null ? null : json["inv_id"],
    tableId: json["table_id"] == null ? null : json["table_id"],
    tableName: json['table_name'] == null ? null : json['table_name'],
    areaName: json['area_name'] == null ? null : json['area_name'],
    seats: json["seats"] == null ? null : json["seats"],
    paymentMethod:
    json["payment_method"] == null ? null : json["payment_method"],
    paymentStatus:
    json["payment_status"] == null ? null : json["payment_status"],
    bulleyeToken: json["bulleyeToken"],
    couponId: json["coupon_id"],
    total: json["total"] == null ? null : json["total"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    tax: json["tax"] == null ? null : json["tax"],
    shipping: json["shipping"] == null ? null : json["shipping"],
    commission: json["commission"] == null ? null : json["commission"],
    discount: json["discount"] == null ? null : json["discount"],
    status: json["status"] == null ? null : json["status"],
    kStatus: json["k_status"] == null ? null : json["k_status"],
    data: json["data"] == null ? null : json["data"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]).toLocal(),
    vendorName: json["vendor_name"] == null ? null : json["vendor_name"],
    orderStatus: json["order_status"] == null ? null : json["order_status"],
    kitchenStatus:
    json["kitchen_status"] == null ? null : json["kitchen_status"],
    orderPaymentStatus: json["order_payment_status"] == null
        ? null
        : json["order_payment_status"],
    orderTypeStatus: json["order_type_status"] == null
        ? null
        : json["order_type_status"],
    date: json["date"] == null ? null : json["date"],
    time: json["time"] == null ? null : json["time"],
    item: json["item"] == null ? null : json["item"],
    vendor:
    json["vendor"] == null ? null : Restaurant.fromMap(json["vendor"]),
    rider: json["rider"],
    orderMeta: json["order_meta"] == null
        ? null
        : List<OrderMetaa>.from(
        json["order_meta"].map((x) => OrderMetaa.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "vendor_id": vendorId == null ? null : vendorId,
    "rider_id": riderId,
    "rider_trigger": riderTrigger == null ? null : riderTrigger,
    "rider_order_completed":
    riderOrderCompleted == null ? null : riderOrderCompleted,
    "seen": seen == null ? null : seen,
    "order_type": orderType == null ? null : orderType,
    "reach_in": reachIn,
    "inv_id": invId == null ? null : invId,
    "table_id": tableId == null ? null : tableId,
    "table_name" : tableName == null ? null : tableName,
    "area_name" : areaName == null ? null : areaName,
    "seats": seats == null ? null : seats,
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "payment_status": paymentStatus == null ? null : paymentStatus,
    "bulleyeToken": bulleyeToken,
    "coupon_id": couponId,
    "total": total == null ? null : total,
    "subtotal": subtotal == null ? null : subtotal,
    "tax": tax == null ? null : tax,
    "shipping": shipping == null ? null : shipping,
    "commission": commission == null ? null : commission,
    "discount": discount == null ? null : discount,
    "status": status == null ? null : status,
    "k_status": kStatus == null ? null : kStatus,
    "data": data == null ? null : data,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "vendor_name": vendorName == null ? null : vendorName,
    "order_status": orderStatus == null ? null : orderStatus,
    "kitchen_status": kitchenStatus == null ? null : kitchenStatus,
    "order_payment_status":
    orderPaymentStatus == null ? null : orderPaymentStatus,
    "order_type_status": orderTypeStatus == null ? null : orderTypeStatus,
    "date": date == null ? null : date,
    "time": time == null ? null : time,
    "item": item == null ? null : item,
    "vendor": vendor == null ? null : vendor!.toMap(),
    "rider": rider,
    "order_meta": orderMeta == null
        ? null
        : List<dynamic>.from(orderMeta!.map((x) => x.toMap())),
  };
}

class OrderMetaa {
  OrderMetaa({
    this.printStatus,
    this.id,
    this.orderId,
    this.termId,
    this.variantName,
    this.variantPrice,
    this.qty,
    this.total,
    this.kStatus,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.kitchenStatus,
    this.products,
    this.orderItemExtras,
  });

  int? printStatus;
  int? id;
  int? orderId;
  int? termId;
  String? variantName;
  String? variantPrice;
  int? qty;
  String? total;
  int? kStatus;
  dynamic status;
  dynamic note;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? kitchenStatus;
  OrderMetaProduct? products;
  List<OrderItemExtraa>? orderItemExtras;

  factory OrderMetaa.fromJson(String str) => OrderMetaa.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderMetaa.fromMap(Map<String, dynamic> json) => OrderMetaa(
    printStatus: json['print_status'] == null ? null : json['print_status'],
    id: json["id"] == null ? null : json["id"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    termId: json["term_id"] == null ? null : json["term_id"],
    variantName: json["variant_name"] == null ? null : json["variant_name"],
    variantPrice:
    json["variant_price"] == null ? null : json["variant_price"],
    qty: json["qty"] == null ? null : json["qty"],
    total: json["total"] == null ? null : json["total"].toString(),
    kStatus: json["k_status"] == null ? null : json["k_status"],
    status: json["status"],
    note: json["note"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]).toLocal(),
    kitchenStatus:
    json["kitchen_status"] == null ? null : json["kitchen_status"],
    products: json["products"] == null
        ? null
        : OrderMetaProduct.fromMap(json["products"]),
    orderItemExtras: json["order_item_extras"] == null
        ? null
        : List<OrderItemExtraa>.from(json["order_item_extras"]
        .map((x) => OrderItemExtraa.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "print_status": printStatus == null ? null : printStatus,
    "id": id == null ? null : id,
    "order_id": orderId == null ? null : orderId,
    "term_id": termId == null ? null : termId,
    "variant_name": variantName == null ? null : variantName,
    "variant_price": variantPrice == null ? null : variantPrice,
    "qty": qty == null ? null : qty,
    "total": total == null ? null : total,
    "k_status": kStatus == null ? null : kStatus,
    "status": status,
    "note": note,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "kitchen_status": kitchenStatus == null ? null : kitchenStatus,
    "products": products == null ? null : products!.toMap(),
    "order_item_extras": orderItemExtras == null
        ? null
        : List<dynamic>.from(orderItemExtras!.map((x) => x.toMap())),
  };
}

class OrderMetaProduct {
  OrderMetaProduct({
    this.id,
    this.title,
    this.type,
    this.description,
    this.total,
    this.discountedPrice,
    this.url,
    this.picture,
    this.excerpt,
    this.price,
    this.discountMeta,
    this.preview,
  });

  int? id;
  String? title;
  int? type;
  String? description;
  dynamic total;
  dynamic discountedPrice;
  String? url;
  String? picture;
  Excerpt? excerpt;
  Price? price;
  dynamic discountMeta;
  Excerpt? preview;

  factory OrderMetaProduct.fromJson(String str) =>
      OrderMetaProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderMetaProduct.fromMap(Map<String, dynamic> json) =>
      OrderMetaProduct(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        type: json["type"] == null ? null : json["type"],
        description: json["description"] == null ? null : json["description"],
        total: json["total"] == null ? null : json["total"].toString(),
        discountedPrice: json["discounted_price"] == null
            ? null
            : json["discounted_price"].toString(),
        url: json["url"] == null ? null : json["url"],
        picture: json["picture"] == null ? null : json["picture"],
        excerpt:
        json["excerpt"] == null ? null : Excerpt.fromMap(json["excerpt"]),
        price: json["price"] == null ? null : Price.fromMap(json["price"]),
        discountMeta: json["discount_meta"],
        preview:
        json["preview"] == null ? null : Excerpt.fromMap(json["preview"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "type": type == null ? null : type,
    "description": description == null ? null : description,
    "total": total == null ? null : total,
    "discounted_price": discountedPrice == null ? null : discountedPrice,
    "url": url == null ? null : url,
    "picture": picture == null ? null : picture,
    "excerpt": excerpt == null ? null : excerpt!.toMap(),
    "price": price == null ? null : price!.toMap(),
    "discount_meta": discountMeta,
    "preview": preview == null ? null : preview!.toMap(),
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
    id: json["id"] == null ? null : json["id"],
    termId: json["term_id"] == null ? null : json["term_id"],
    type: json["type"] == null ? null : json["type"],
    content: json["content"] == null ? null : json["content"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "term_id": termId == null ? null : termId,
    "type": type == null ? null : type,
    "content": content == null ? null : content,
    "image": image == null ? null : image,
  };
}

class Price {
  Price({
    this.id,
    this.termId,
    this.price,
  });

  int? id;
  int? termId;
  dynamic price;

  factory Price.fromJson(String str) => Price.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Price.fromMap(Map<String, dynamic> json) => Price(
    id: json["id"] == null ? null : json["id"],
    termId: json["term_id"] == null ? null : json["term_id"],
    price: json["price"] == null ? null : json["price"].toString(),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "term_id": termId == null ? null : termId,
    "price": price == null ? null : price,
  };
}

class OrderItemExtraa {
  OrderItemExtraa({
    this.id,
    this.extraName,
    this.extraPrice,
    this.orderMetaId,
  });

  int? id;
  String? extraName;
  String? extraPrice;
  int? orderMetaId;

  factory OrderItemExtraa.fromJson(String str) =>
      OrderItemExtraa.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderItemExtraa.fromMap(Map<String, dynamic> json) => OrderItemExtraa(
    id: json["id"] == null ? null : json["id"],
    extraName: json["extra_name"] == null ? null : json["extra_name"],
    extraPrice: json["extra_price"] == null ? null : json["extra_price"],
    orderMetaId:
    json["order_meta_id"] == null ? null : json["order_meta_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "extra_name": extraName == null ? null : extraName,
    "extra_price": extraPrice == null ? null : extraPrice,
    "order_meta_id": orderMetaId == null ? null : orderMetaId,
  };
}
