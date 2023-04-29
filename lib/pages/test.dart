import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:Mealsmash_Waiter/helper/colors.dart';

import 'package:Mealsmash_Waiter/model/usbDevicesModel.dart';
import 'package:Mealsmash_Waiter/widgets/my_back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class PrinterSetups extends StatefulWidget {
  const PrinterSetups({key}) : super(key: key);

  @override
  _PrinterSetupState createState() => _PrinterSetupState();
}

class _PrinterSetupState extends State<PrinterSetups> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // LoginModel loginModelItems = LoginModel();
  var email;
  var password;
  var pref;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _bluetoothDevice;

  bool _connected = false;
  bool _pressed = false;

  List<Map<String, dynamic>> devices = [];
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;
  List<Map<String, dynamic>> results = [];
  List<UsbData> _usbDevices = [];
  String _usbSelectedDevice = "";
  late UsbData _mapUsbSelectedDevice;

  @override
  void initState() {
    super.initState();

    initPlatformState().whenComplete(() {
      setState(() {});
    });
    getShared();
    _getDevicelist().whenComplete(() {
      setState(() {});
    });
  }

  getShared() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
      _bluetoothDevice = devices.first;
      // print(devices.first.name);
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _bluetoothDevice = devices.first;
      _devices = devices;
    });
  }

  bool isCheckedBluetooth = false;
  bool isCheckedUsb = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    // ProductProvider productProvider = Provider.of<ProductProvider>(context);
    // var locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BasicColors.getWhiteBlackColor(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            MyBackButton(),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('printsetupp'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: BasicColors.getBlackWhiteColor())),
            )
          ],
        ),
      ),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Spacer(),
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.width / 10,
                              width: MediaQuery.of(context).size.width / 10,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.asset(
                                  "assets/logo.png",
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "selectprinterdevice".tr
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                    fontSize: 22,
                                    color: BasicColors.getBlackWhiteColor(),
                                    // color: Colors.blueGrey.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),

                          // message with checkbox for bluetooth printer
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                                value: isCheckedBluetooth,
                                onChanged: (value) {
                                  setState(() {
                                    isCheckedBluetooth = value!;
                                    isCheckedUsb = false;
                                  });
                                },
                              ),
                              // Icon(
                              //   Icons.print,
                              //   color: Theme.of(context).primaryColor,
                              // ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Text(
                                "bluetooth".tr,
                                style: TextStyle(
                                  color: BasicColors.getBlackWhiteColor(),
                                  fontSize: 22,
                                  // color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // checkbox with printer message  printer usb devices
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                                value: isCheckedUsb,
                                onChanged: (value) {
                                  setState(() {
                                    isCheckedUsb = value!;
                                    isCheckedBluetooth = false;
                                  });
                                },
                              ),
                              // Icon(
                              //   Icons.print,
                              //   color: Theme.of(context).primaryColor,
                              // ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Text(
                                "usbprinterr".tr,
                                style: TextStyle(
                                  color: BasicColors.getBlackWhiteColor(),
                                  fontSize: 22,

                                  // color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // Dropdown  list Bluetooth devices:  with connect button and test print button
                          isCheckedBluetooth == true && isCheckedUsb == false
                              ? Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.print,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Bluetooth Printer Devices",
                                    style: TextStyle(
                                      color: BasicColors
                                          .getBlackWhiteColor(),
                                      fontSize: 22,

                                      // color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.3,
                                    child:
                                    DropdownButton<BluetoothDevice>(
                                        dropdownColor: BasicColors
                                            .getWhiteBlackColor(),
                                        items: _getDeviceItems(),
                                        onChanged: (value) {
                                          setState(() {
                                            _bluetoothDevice = value!;
                                          });
                                        },
                                        value: _bluetoothDevice),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.1),
                                    ),
                                    onPressed: () {
                                      _connectBluetooth(
                                          "connect Bluetooth");
                                    },
                                    child: Text(
                                      "connect",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith( fontSize: 22,

                                          color: Colors.green,
                                          fontWeight:
                                          FontWeight.bold),

                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                        Colors.grey.withOpacity(0.1),
                                      ),
                                      onPressed: () {
                                        _testBluetoothPrint(
                                            "Test printer");
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          "test Print",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith( fontSize: 22,

                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                              : Container(),
                          // SizedBox(
                          //   height: 50,
                          // ),

                          // Dropdown list of usb Devices with connect and text print buttons.
                          isCheckedBluetooth == false && isCheckedUsb == true
                              ? Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.print,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("usbprinterr".tr,
                                      style: TextStyle(
                                        color: Colors.grey[600] ,                                  fontSize: 22,

                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.3,
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.03,

                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: _usbSelectedDevice,
                                        isDense: true,
                                        onChanged: (newValue) async {
                                          setState(() {
                                            _usbSelectedDevice = newValue!;
                                          });
                                          Fluttertoast.showToast(
                                              msg: _usbSelectedDevice,
                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          for (int i = 0;
                                          i < _usbDevices.length;
                                          i++) {
                                            if (_usbDevices[i]
                                                .productName ==
                                                newValue) {
                                              _mapUsbSelectedDevice =
                                              _usbDevices[i];
                                            }
                                          }

                                          Fluttertoast.showToast(
                                              msg: _mapUsbSelectedDevice
                                                  .productId,
                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          print("usssbbb devicee${_usbSelectedDevice}");
                                        },
                                        items:
                                        _usbDevices.map((UsbData map) {
                                          return new DropdownMenuItem<
                                              String>(
                                            value: map.productName,
                                            child: new Text(map.productName,
                                              style: new TextStyle(
                                                  color: Colors.black,fontSize: 20),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Spacer(),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                        Colors.grey.withOpacity(0.1),
                                      ),
                                      onPressed: () {
                                        _connectUsb(
                                            int.parse(_mapUsbSelectedDevice
                                                .vendorId),
                                            int.parse(_mapUsbSelectedDevice
                                                .productId));
                                        Fluttertoast.showToast(
                                            msg:
                                            "venID ${results[0]['vendorId']} ProdID ${results[0]['productId']}  ",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                      child: Text(
                                        "connect",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(                                  fontSize: 22,

                                            color: Colors.green,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                          Colors.grey.withOpacity(0.1),
                                        ),
                                        onPressed: () {
                                          _print();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            "test Print",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(                                  fontSize: 22,

                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                              : Container(),
                          SizedBox(
                            height: 50,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // _connect();
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.red,
                        Colors.red,
                        // buttonColor,
                        // buttonColor,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "don".tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 26,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        beginOffset: Offset(0.0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      print(_devices);
      for (var a in _devices) {
        items.add(DropdownMenuItem(
          child: Text(
            a.name!,
            style: TextStyle(color: BasicColors.getBlackWhiteColor(),fontSize: 22,
            ),
          ),
          value: a,
        ));
      }
    }
    return items;
  }

  void _connectBluetooth(locale) {
    if (_bluetoothDevice == null) {
      Fluttertoast.showToast(
          msg: locale.noDeviceSelected,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_bluetoothDevice!).catchError((error) {
            // _pressed = true;
            // setState(() {
            //
            // });
            // print("connected successfully");
            Fluttertoast.showToast(
                msg: error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            // Navigator.pop(context);
          });
          // setState(() => _pressed = true);

        } else {
          _pressed = true;
          setState(() {});
          print("connected successfully");
          Fluttertoast.showToast(
              msg: "connected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  void _testBluetoothPrint([locale]) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        // bluetooth.printNewLine();

        bluetooth.print3Column('title', 'qty', 'dssfd', 1,
            format: "%-1s %10s %10s %n");
        bluetooth.printCustom(
            "----------------------------------------------------", 0, 1);
        // bluetooth.printCustom("HEADER",3,1);
        // bluetooth.printNewLine();
        // bluetooth.printImage(pathImage);   //path of your image/logo
        // bluetooth.printNewLine();
        // //bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        // bluetooth.printLeftRight("LEFT", "RIGHT",0);
        // bluetooth.printLeftRight("LEFT", "RIGHT",1);
        // bluetooth.printLeftRight("LEFT", "RIGHT",1,format: "%-15s %15s %n");
        // bluetooth.printNewLine();
        // bluetooth.printLeftRight("LEFT", "RIGHT",2);
        // bluetooth.printLeftRight("LEFT", "RIGHT",3);
        // bluetooth.printLeftRight("LEFT", "RIGHT",4);
        // bluetooth.printNewLine();
        // bluetooth.print3Column("Col1", "Col2", "Col3",1);
        // bluetooth.print3Column("Col1", "Col2", "Col3",1,format: "%-10s %10s %10s %n");
        // bluetooth.printNewLine();
        // bluetooth.print4Column("Col1","Col2","Col3","Col4",1);
        // bluetooth.print4Column("Col1","Col2","Col3","Col4",1,format: "%-8s %7s %7s %7s %n" );
        // bluetooth.printNewLine();
        // String testString = " čĆžŽšŠ-H-ščđ";
        // bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
        // bluetooth.printLeftRight("Številka:", "18000001", 1, charset: "windows-1250");
        // bluetooth.printCustom("Body left",1,0);
        // bluetooth.printCustom("Body right",0,2);
        // bluetooth.printNewLine();
        // bluetooth.printCustom("Thank You",2,1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        // bluetooth.paperCut();
      } else {
        // print("not connected");
        Fluttertoast.showToast(
            msg: locale.notConnectedPleaseRestartYourPrinterAndTryAgain,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  _getDevicelist() async {
    results = await FlutterUsbPrinter.getUSBDeviceList();

    _usbDevices =
        (results).map<UsbData>((item) => UsbData.fromJson(item)).toList();

    _usbSelectedDevice = _usbDevices[0].productName;
    _mapUsbSelectedDevice = _usbDevices[0];

    // Fluttertoast.showToast(
    //     msg: "$results",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    setState(() {
      devices = results;
    });
  }

  _connectUsb(int vendorId, int productId) async {
    bool returned = false;
    try {
      returned = (await flutterUsbPrinter.connect(vendorId, productId))!;
      if (returned) {
        Fluttertoast.showToast(
            msg: "Connected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);

        pref.setString('printerVendorId', vendorId.toString());
        pref.setString('printerProductId', productId.toString());
      }
    } on PlatformException {
      String response = 'Failed to get Connect';
      Fluttertoast.showToast(
          msg: response,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (returned) {
      // Fluttertoast.showToast(
      //     msg: 'Connected',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      setState(() {
        connected = true;
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Exception',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _print() async {
    try {
      // File file = new File('assets/document.pdf');
      // await file.writeAsBytes(await pdf.save());

      // var file = await _downloadFile(
      //     "http://www.africau.edu/images/default/sample.pdf", "test.pdf");
      // await FlutterPdfPrinter.printFile(file.path);
      DateTime now = DateTime.now();
      var data = Uint8List.fromList(utf8.encode(""));

      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(await pdf.save());
      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data2);
      await flutterUsbPrinter
          .printText(DateFormat('kk:mm:ss , EEE d MMM').format(now) + "\n");
      await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("                   MEALSMASH                 \n");
      await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("Date:                   Time:                \n");
      await flutterUsbPrinter
          .printText("Payment Type:                                \n");
      await flutterUsbPrinter
          .printText("Invoice:                Order Type:          \n");
      await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("---------------------------------------------\n");
      await flutterUsbPrinter
          .printText("                 Sale Receipt                \n");
      await flutterUsbPrinter
          .printText("---------------------------------------------\n");
      await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("ITEMS                                  TOTAL\n");
      await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter.printText("Chicken Shawarma\n");
      await flutterUsbPrinter.printText("\t \t \t \$ 24\n");
      // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
      // await flutterUsbPrinter.printText("Chicken Shawarma                        \$ 24\n");
      await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("---------------------------------------------\n");
      await flutterUsbPrinter
          .printText("Sub Total                               \$ 24\n");
      // await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("Discount                                \$ 24\n");
      // await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("Tax                                     \$ 24\n");
      // await flutterUsbPrinter.printText("\n");
      await flutterUsbPrinter
          .printText("Net Payable                             \$ 24\n");
      await flutterUsbPrinter
          .printText("---------------------------------------------\n");



      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data);
      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data);
      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data2);
      // await flutterUsbPrinter.write(data);
      // await flutterUsbPrinter.write(data2);
    } on PlatformException {
      String response = 'Failed to get platform version.';
      Fluttertoast.showToast(
          msg: response,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response);
    }
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes = '' as Uint8List;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }
}
