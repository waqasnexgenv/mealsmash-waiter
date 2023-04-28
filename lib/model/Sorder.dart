// To parse this JSON data, do
//
//     final sOrder = sOrderFromJson(jsonString);

import 'dart:convert';

SOrder sOrderFromJson(String? str) => SOrder.fromJson(json.decode(str!));

String? sOrderToJson(SOrder data) => json.encode(data.toJson());

class SOrder {
  SOrder({
    this.status,
    this.message,
    this.order,
  });

  bool? status;
  String? message;
  SQOrder? order;

  factory SOrder.fromJson(Map<String, dynamic> json) => SOrder(
        status: json["status"],
        message: json["message"],
        order: SQOrder.fromMap(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "order": order?.toJson(),
      };
}

class Ordermeta {
  Ordermeta({
    this.id,
    this.orderId,
    this.termId,
    this.variantId,
    this.departmentId,
    this.printStatus,
    this.variantName,
    this.variantPrice,
    this.qty,
    this.total,
    this.kStatus,
    this.status,
    this.note,
    this.squareItemId,
    this.createdAt,
    this.updatedAt,
    this.kitchenStatus,
    this.squareItems,
    this.orderItemExtras,
  });

  int? id;
  int? orderId;
  dynamic termId;
  dynamic variantId;
  int? departmentId;
  int? printStatus;
  String? variantName;
  String? variantPrice;
  int? qty;
  int? total;
  int? kStatus;
  String? status;
  dynamic note;
  String? squareItemId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? kitchenStatus;
  SquareItems? squareItems;
  List<OrderItemExtras>? orderItemExtras;

  factory Ordermeta.fromMap(Map<String, dynamic> json) => Ordermeta(
        id: json["id"],
        orderId: json["order_id"],
        termId: json["term_id"],
        variantId: json["variant_id"],
        departmentId: json["department_id"],
        printStatus: json["print_status"],
        variantName: json["variant_name"],
        variantPrice: json["variant_price"],
        qty: json["qty"],
        total: json["total"],
        kStatus: json["k_status"],
        status: json["status"],
        note: json["note"],
        squareItemId: json["square_item_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        kitchenStatus: json["kitchen_status"],
        squareItems: json["square_items"] == null
            ? null
            : SquareItems.fromJson(json["square_items"]),
        orderItemExtras: json["order_item_extras"] == null
            ? null
            : List<OrderItemExtras>.from(json["order_item_extras"]
                .map((x) => OrderItemExtras.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "order_id": orderId,
        "term_id": termId,
        "variant_id": variantId,
        "department_id": departmentId,
        "print_status": printStatus,
        "variant_name": variantName,
        "variant_price": variantPrice,
        "qty": qty,
        "total": total,
        "k_status": kStatus,
        "status": status,
        "note": note,
        "square_item_id": squareItemId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "kitchen_status": kitchenStatus,
        "square_items": squareItems == null ? null : squareItems?.toJson(),
        "order_item_extras": orderItemExtras == null
            ? null
            : List<dynamic>.from(orderItemExtras!.map((x) => x.toJson())),
      };
}

class OrderItemExtras {
  OrderItemExtras({
    this.id,
    this.extraName,
    this.extraPrice,
    this.orderMetaId,
  });

  int? id;
  String? extraName;
  String? extraPrice;
  int? orderMetaId;

  factory OrderItemExtras.fromJson(Map<String, dynamic> json) =>
      OrderItemExtras(
        id: json["id"],
        extraName: json["extra_name"],
        extraPrice: json["extra_price"],
        orderMetaId: json["order_meta_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "extra_name": extraName,
        "extra_price": extraPrice,
        "order_meta_id": orderMetaId,
      };
}

class SquareItems {
  SquareItems({
    this.id,
    this.itemId,
    this.title,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? itemId;
  String? title;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SquareItems.fromJson(Map<String, dynamic> json) => SquareItems(
        id: json["id"],
        itemId: json["item_id"],
        title: json["title"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "title": title,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}





















class SQOrder {
  SQOrder({
    this.id,
    this.userId,
    this.vendorId,
    this.riderId,
    this.reservationId,
    this.riderTrigger,
    this.riderOrderCompleted,
    this.seen,
    this.orderType,
    this.reachIn,
    this.invId,
    this.note,
    this.tableId,
    this.seats,
    this.paymentMethod,
    this.paymentStatus,
    this.bulleyeToken,
    this.couponId,
    this.total,
    this.subtotal,
    this.devliveryFee,
    this.tax,
    this.shipping,
    this.commission,
    this.discount,
    this.status,
    this.kStatus,
    this.orderOrigin,
    this.data,
    this.platform,
    this.squareOrderId,
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
    this.tableName,
    this.areaName,
    // this.ordermeta,
    this.vendor,
    this.rider,
    this.orderMeta,
  });

  int? id;
  int? userId;
  int? vendorId;
  dynamic riderId;
  dynamic reservationId;
  int? riderTrigger;
  int? riderOrderCompleted;
  int? seen;
  String? orderType;
  dynamic reachIn;
  String? invId;
  dynamic note;
  int? tableId;
  dynamic seats;
  String? paymentMethod;
  String? paymentStatus;
  dynamic bulleyeToken;
  dynamic couponId;
  String? total;
  String? subtotal;
  String? devliveryFee;
  String? tax;
  String? shipping;
  int? commission;
  String? discount;
  int? status;
  int? kStatus;
  String? orderOrigin;
  String? data;
  String? platform;
  dynamic squareOrderId;
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
  String? tableName;
  String? areaName;

  // List<Ordermeta>? ordermeta;
  Vendor? vendor;
  dynamic rider;
  List<Ordermeta>? orderMeta;

  factory SQOrder.fromMap(Map<String, dynamic> json) => SQOrder(
        id: json["id"],
        userId: json["user_id"],
        vendorId: json["vendor_id"],
        riderId: json["rider_id"],
        reservationId: json["reservation_id"],
        riderTrigger: json["rider_trigger"],
        riderOrderCompleted: json["rider_order_completed"],
        seen: json["seen"],
        orderType: json["order_type"],
        reachIn: json["reach_in"],
        invId: json["inv_id"],
        note: json["note"],
        tableId: json["table_id"],
        seats: json["seats"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        bulleyeToken: json["bulleyeToken"],
        couponId: json["coupon_id"],
        total: json["total"],
        subtotal: json["subtotal"],
        devliveryFee: json["devlivery_fee"],
        tax: json["tax"],
        shipping: json["shipping"],
        commission: json["commission"],
        discount: json["discount"],
        status: json["status"],
        kStatus: json["k_status"],
        orderOrigin: json["order_origin"],
        data: json["data"],
        platform: json["platform"],
        squareOrderId: json["square_order_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        vendorName: json["vendor_name"],
        orderStatus: json["order_status"],
        kitchenStatus: json["kitchen_status"],
        orderPaymentStatus: json["order_payment_status"],
        orderTypeStatus: json["order_type_status"],
        date: json["date"],
        time: json["time"],
        item: json["item"],
        tableName: json["table_name"],
        areaName: json["area_name"],
        // ordermeta: List<Ordermeta>.from(
        //     json["ordermeta"].map((x) => Ordermeta.fromJson(x))),
        vendor: Vendor.fromJson(json["vendor"]),
        rider: json["rider"],
    orderMeta: json["order_meta"] == null
        ? null
        : List<Ordermeta>.from(
        json["ordermeta"].map((x) => Ordermeta.fromMap(x))),
    // orderMeta: List<Ordermeta>.from(
    //     json["order_meta"].map((x) => Ordermeta.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "vendor_id": vendorId,
        "rider_id": riderId,
        "reservation_id": reservationId,
        "rider_trigger": riderTrigger,
        "rider_order_completed": riderOrderCompleted,
        "seen": seen,
        "order_type": orderType,
        "reach_in": reachIn,
        "inv_id": invId,
        "note": note,
        "table_id": tableId,
        "seats": seats,
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "bulleyeToken": bulleyeToken,
        "coupon_id": couponId,
        "total": total,
        "subtotal": subtotal,
        "devlivery_fee": devliveryFee,
        "tax": tax,
        "shipping": shipping,
        "commission": commission,
        "discount": discount,
        "status": status,
        "k_status": kStatus,
        "order_origin": orderOrigin,
        "data": data,
        "platform": platform,
        "square_order_id": squareOrderId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "vendor_name": vendorName,
        "order_status": orderStatus,
        "kitchen_status": kitchenStatus,
        "order_payment_status": orderPaymentStatus,
        "order_type_status": orderTypeStatus,
        "date": date,
        "time": time,
        "item": item,
        "table_name": tableName,
        "area_name": areaName,
        // "ordermeta": List<dynamic>.from(ordermeta!.map((x) => x.toJson())),
        "vendor": vendor?.toJson(),
        "rider": rider,
    "ordermeta": orderMeta == null
        ? null
        : List<dynamic>.from(orderMeta!.map((x) => x.toMap())),
    // "order_meta": List<dynamic>.from(orderMeta!.map((x) => x.toJson())),
        // "order_meta": List<dynamic>.from(orderMeta!.map((x) => x.toJson())),
      };
}

class Vendor {
  Vendor({
    this.id,
    this.roleId,
    this.badgeId,
    this.planId,
    this.vendorId,
    this.categoryId,
    this.slug,
    this.avatar,
    this.landingImage,
    this.name,
    this.email,
    this.balance,
    this.provider,
    this.providerUserId,
    this.phone,
    this.emailToken,
    this.pidetutransporteToken,
    this.bulleyeToken,
    this.status,
    this.latitude,
    this.longitude,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.url,
    this.myCategory,
    this.distance,
    this.deliveryPrice,
    this.platformConfigured,
    this.categories,
    this.location,
    this.square,
  });

  int? id;
  int? roleId;
  int? badgeId;
  int? planId;
  dynamic vendorId;
  int? categoryId;
  String? slug;
  String? avatar;
  String? landingImage;
  String? name;
  String? email;
  int? balance;
  dynamic provider;
  dynamic providerUserId;
  dynamic phone;
  dynamic emailToken;
  String? pidetutransporteToken;
  String? bulleyeToken;
  String? status;
  dynamic latitude;
  dynamic longitude;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  String? url;
  List<String>? myCategory;
  double? distance;
  int? deliveryPrice;
  String? platformConfigured;
  List<SOrderCategory>? categories;
  Location? location;
  Square? square;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        roleId: json["role_id"],
        badgeId: json["badge_id"],
        planId: json["plan_id"],
        vendorId: json["vendor_id"],
        categoryId: json["category_id"],
        slug: json["slug"],
        avatar: json["avatar"],
        landingImage: json["landing_image"],
        name: json["name"],
        email: json["email"],
        balance: json["balance"],
        provider: json["provider"],
        providerUserId: json["provider_user_id"],
        phone: json["phone"],
        emailToken: json["email_token"],
        pidetutransporteToken: json["pidetutransporte_token"],
        bulleyeToken: json["bulleyeToken"],
        status: json["status"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        url: json["url"],
        myCategory: List<String>.from(json["my_category"].map((x) => x)),
        distance: json["distance"].toDouble(),
        deliveryPrice: json["delivery_price"],
        platformConfigured: json["platform_configured"],
        categories: List<SOrderCategory>.from(
            json["categories"].map((x) => SOrderCategory.fromJson(x))),
        location: Location.fromJson(json["location"]),
        square: Square.fromJson(json["square"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "badge_id": badgeId,
        "plan_id": planId,
        "vendor_id": vendorId,
        "category_id": categoryId,
        "slug": slug,
        "avatar": avatar,
        "landing_image": landingImage,
        "name": name,
        "email": email,
        "balance": balance,
        "provider": provider,
        "provider_user_id": providerUserId,
        "phone": phone,
        "email_token": emailToken,
        "pidetutransporte_token": pidetutransporteToken,
        "bulleyeToken": bulleyeToken,
        "status": status,
        "latitude": latitude,
        "longitude": longitude,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "image": image,
        "url": url,
        "my_category": List<dynamic>.from(myCategory!.map((x) => x)),
        "distance": distance,
        "delivery_price": deliveryPrice,
        "platform_configured": platformConfigured,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "location": location?.toJson(),
        "square": square?.toJson(),
      };
}

class SOrderCategory {
  SOrderCategory({
    this.id,
    this.name,
    this.slug,
    this.status,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.iconAddress,
    this.pivot,
  });

  int? id;
  String? name;
  String? slug;
  String? status;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? iconAddress;
  Pivot? pivot;

  factory SOrderCategory.fromJson(Map<String, dynamic> json) => SOrderCategory(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        status: json["status"],
        icon: json["icon"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        iconAddress: json["icon_address"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "status": status,
        "icon": icon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "icon_address": iconAddress,
        "pivot": pivot!.toJson(),
      };
}

class Pivot {
  Pivot({
    this.restId,
    this.catId,
  });

  int? restId;
  int? catId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        restId: json["rest_id"],
        catId: json["cat_id"],
      );

  Map<String, dynamic> toJson() => {
        "rest_id": restId,
        "cat_id": catId,
      };
}

class Location {
  Location({
    this.userId,
    this.termId,
    this.latitude,
    this.longitude,
  });

  int? userId;
  int? termId;
  double? latitude;
  double? longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        userId: json["user_id"],
        termId: json["term_id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "term_id": termId,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Square {
  Square({
    this.id,
    this.userId,
    this.deviceId,
    this.apiToken,
    this.platform,
    this.active,
    this.authorized,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? deviceId;
  String? apiToken;
  String? platform;
  int? active;
  int? authorized;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Square.fromJson(Map<String, dynamic> json) => Square(
        id: json["id"],
        userId: json["user_id"],
        deviceId: json["device_id"],
        apiToken: json["api_token"],
        platform: json["platform"],
        active: json["active"],
        authorized: json["authorized"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "device_id": deviceId,
        "api_token": apiToken,
        "platform": platform,
        "active": active,
        "authorized": authorized,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
