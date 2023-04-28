import 'dart:convert';
import 'dart:core';

import 'Sorder.dart';
import 'order.dart';

class TablesResponse {
  TablesResponse({
    this.status,
    this.data,
  });

  bool? status;
  List<MyTable>? data;

  factory TablesResponse.fromJson(String str) =>
      TablesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TablesResponse.fromMap(Map<String, dynamic> json) => TablesResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<MyTable>.from(json["data"].map((x) => MyTable.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

// class Area{
//   Area({
//
// });
//   int? id;
//   int? vendor_id;
//   String? name;
//   String? description;
//   MyTable?
// "id":14,
// "vendor_id":2616,
// "name":"Ground Floor",
// "description":"Ground Floor",
// "created_at":"2022-03-30T11:04:02.000000Z",
// "updated_at":"2022-03-30T11:04:02.000000Z",
// }

class MyTable {
  MyTable({
    this.id,
    this.vendorId,
    this.name,
    this.seat,
    this.areaId,
    this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.ongoingOrder,
    this.ongoing_order_square,
  });

  int? id;
  int? vendorId;
  String? name;
  String? seat;
  int? areaId;
  String? status;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  Order? ongoingOrder;

  SQOrder? ongoing_order_square;

  // SOrder? songoingOrder;

  factory MyTable.fromJson(String str) => MyTable.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyTable.fromMap(Map<String, dynamic> json) => MyTable(
        id: json["id"] == null ? null : json["id"],
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        name: json["name"] == null ? null : json["name"],
        seat: json["seat"] == null ? null : json["seat"],
        areaId: json["area_id"] == null ? null : json["area_id"],
        status: json["status"] == null ? null : json["status"],
        description: json["description"] == null ? null : json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        ongoingOrder: json["ongoing_order"] == null
            ? null
            : Order.fromMap(json["ongoing_order"]),
        ongoing_order_square: json["ongoing_order_square"] == null
            ? null
            : SQOrder.fromMap(json["ongoing_order_square"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "vendor_id": vendorId == null ? null : vendorId,
        "name": name == null ? null : name,
        "seat": seat == null ? null : seat,
        "area_id": areaId == null ? null : areaId,
        "status": status == null ? null : status,
        "description": description == null ? null : description,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "ongoing_order": ongoingOrder == null ? null : ongoingOrder!.toMap(),
        "ongoing_order_square": ongoing_order_square == null
            ? null
            : ongoing_order_square!.toJson(),
      };
}
