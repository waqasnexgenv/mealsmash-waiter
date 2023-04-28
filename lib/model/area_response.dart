import 'dart:convert';

class AreaResponse {
  AreaResponse({this.areaName, this.floorId});

  // "id":14,
  // "vendor_id":2616,
  // "name":"Ground Floor",
  // "description":"Ground Floor",
  // "created_at":"2022-03-30T11:04:02.000000Z",
  // "updated_at":"2022-03-30T11:04:02.000000Z",

  String? areaName;
  int? floorId;

  factory AreaResponse.fromJson(String str) =>
      AreaResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AreaResponse.fromMap(Map<String, dynamic> json) => AreaResponse(
        areaName: json["name"] == null ? null : json["name"],
        floorId: json['id'] == null ? null : json['id'],
      );

  Map<String, dynamic> toMap() => {
        "name": areaName == null ? null : areaName,
        "id": floorId == null ? null : floorId,
      };
}
