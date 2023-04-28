import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hungerz_ordering/model/order.dart';

import '../common_controller.dart';

class BaseClient {
  final CommonController controller = Get.find<CommonController>();

  Order? orderPaid;

  noInternet() {
    controller.showToast("noInternet".tr);
  }

  connectionTimeOut() {
    controller.showToast("timeOutError".tr);
  }

  serverError() {
    controller.showToast("serverError".tr);
  }

  unKnownErrorOccurred() {
    controller.showToast("unknownErrorOccurred".tr);
  }

  badRequestError() {
    controller.showToast("badRequestErrorOccurred".tr);
  }

  unAuthenticatedError() {
    controller.showToast("unAuthenticatedErrorOccurred".tr);
  }

  accessDeniedError() {
    controller.showToast("accessDeniedErrorOccurred".tr);
  }

  methodNotAllowedError() {
    controller.showToast("methodNotAllowedError".tr);
  }

  static const int timeOutDuration = 20;

  // GET
  Future<dynamic> get(String url) async {
    //print("Url: $url");
    var uri = Uri.parse(url);
    try {
      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: timeOutDuration));
      log("$url ${response.body}");

      return _processResponse(response);
    } on SocketException {
      noInternet();
    } on TimeoutException {
      connectionTimeOut();
    }
  }

  // POST
  Future<dynamic> post(String url, dynamic jsonBody) async {
    //print("Url: $url");
    var uri = Uri.parse(url);
    try {
      var response = await http.post(
        uri,
        body: jsonBody,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: timeOutDuration));
      log("$url ${response.body}");

      return _processResponse(response);
    } on SocketException {
      noInternet();
    } on TimeoutException {
      connectionTimeOut();
    }
  }

  // GET with Auth
  Future<dynamic> getWithAuth(
      String url,   {bool istableapi = false, int? i}
  ) async {
    //print("Url: $url");
    var uri = Uri.parse(url);
    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': "Bearer ${controller.restaurant.value.token}",
          // Get Logged In User Token and Add to Request
        },
      ).timeout( Duration(seconds: i??timeOutDuration));

      if(!istableapi) log("$url ${response.body}");

      // print(orderPaid);
      return _processResponse(response);
    } on SocketException {
      noInternet();
    } on TimeoutException {
     if(!istableapi) connectionTimeOut();
    }
  }

  // POST with Auth
  Future<dynamic> postWithAuth(String url, dynamic jsonBody) async {
    print("Url: $url");
    var uri = Uri.parse(url);
    try {
      print("tttttt");
      print("${controller.restaurant.value.token}");
      print("$jsonBody");
      var response = await http.post(
        uri,
        body: jsonEncode(jsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': "Bearer ${controller.restaurant.value.token}",
          // Get Logged In User Token and Add to Request
        },
      ).timeout(const Duration(seconds: timeOutDuration));
      log("$url ${response.body}");
      return _processResponse(response);
    } on SocketException {
      noInternet();
    } on TimeoutException {
      connectionTimeOut();
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        // Bad Request Format or in valid Data Provided
        badRequestError();
        return null;
      case 401:
        // Un Authorized - Login Again
        unAuthenticatedError();
        //studentController.logOutUser();
        return null;
      case 403:
        // Access Denied
        accessDeniedError();
        return null;
      case 405:
        // Method Not Allowed
        methodNotAllowedError();
        return null;
      case 500:
        // Un  - Login Again
        serverError();
        return null;
      default:
        // Unknown Error
        unKnownErrorOccurred();
        return null;
    }
  }
}
