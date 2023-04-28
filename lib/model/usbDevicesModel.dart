// To parse this JSON data, do
//
//     final usbData = usbDataFromJson(jsonString);

import 'dart:convert';

List<UsbData> usbDataFromJson(String str) =>
    List<UsbData>.from(json.decode(str).map((x) => UsbData.fromJson(x)));

String usbDataToJson(List<UsbData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsbData {
  UsbData({
    required this.productId,
    required this.vendorId,
    required this.deviceName,
    required this.deviceId,
    required this.productName,
    required this.manufacturer,
  });

  String productId;
  String vendorId;
  String deviceName;
  String deviceId;
  String productName;
  String manufacturer;

  factory UsbData.fromJson(Map<String, dynamic> json) => UsbData(
        productId: json["productId"] == null ? null : json["productId"],
        vendorId: json["vendorId"] == null ? null : json["vendorId"],
        deviceName: json["deviceName"] == null ? null : json["deviceName"],
        deviceId: json["deviceId"] == null ? null : json["deviceId"],
        productName: json["productName"] == null ? null : json["productName"],
        manufacturer:
            json["manufacturer"] == null ? null : json["manufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId == null ? null : productId,
        "vendorId": vendorId == null ? null : vendorId,
        "deviceName": deviceName == null ? null : deviceName,
        "deviceId": deviceId == null ? null : deviceId,
        "productName": productName == null ? null : productName,
        "manufacturer": manufacturer == null ? null : manufacturer,
      };
}
