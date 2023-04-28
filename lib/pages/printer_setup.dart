import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungerz_ordering/helper/app_config.dart';

import '../helper/colors.dart';
import '../widgets/my_back_button.dart';

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
import 'package:hungerz_ordering/helper/colors.dart';

import 'package:hungerz_ordering/model/usbDevicesModel.dart';
import 'package:hungerz_ordering/widgets/my_back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class PrinterSetup extends StatefulWidget {
  const PrinterSetup({Key? key}) : super(key: key);

  @override
  State<PrinterSetup> createState() => PrinterSetupState();
}

class PrinterSetupState extends State<PrinterSetup> {
  // Printer Type [bluetooth, usb, network]
  var defaultPrinterType = PrinterType.bluetooth;
  var _isBle = false;
  var _reconnect = false;
  var _isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;
var pref;
  // _currentUsbStatus is only supports on Android
  // ignore: unused_field
  USBStatus _currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  BluetoothPrinter? selectedPrinter;

  get isBle => _isBle;


  List<String> Papersize = [ '80mm','58mm',];
  String? _selectedpaper;

Configure() async {
  print("paperrrr");
  pref = await SharedPreferences.getInstance();
  String? selectedpapersize=pref.getString('paper');
if(

selectedpapersize==null || selectedpapersize==""
){
  _selectedpaper='80mm';
  print("paperrrr");
}
else{
  _selectedpaper=selectedpapersize;
  print("paperrrr2");

}
  var paper = _selectedpaper;
  pref.setString('paper', paper);
}

  @override
  void initState() {
    Configure();
    print("selectedpaper...${_selectedpaper}");
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    _scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus =
        PrinterManager.instance.stateBluetooth.listen((status) {
          log(' ----------------- status bt $status ------------------ ');
          print("    waas $status");
          _currentStatus = status;
          if (status == BTStatus.connected) {
            setState(() {
              _isConnected = true;
            });
          }
          if (status == BTStatus.none) {
            setState(() {
              _isConnected = false;
            });
          }
          if (status == BTStatus.connected && pendingTask != null) {
            if (Platform.isAndroid) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                PrinterManager.instance
                    .send(type: PrinterType.bluetooth, bytes: pendingTask!);
                pendingTask = null;
              });
            } else if (Platform.isIOS) {
              PrinterManager.instance
                  .send(type: PrinterType.bluetooth, bytes: pendingTask!);
              pendingTask = null;
            }
          }
        });
    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance
                .send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    AppConfig.printerSetupState = this;
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void _scan() {
    devices.clear();
    _subscription = printerManager
        .discovery(type: defaultPrinterType, isBle: _isBle)
        .listen((device) {
      devices.add(BluetoothPrinter(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
      setState(() {});
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance
            .disconnect(type: selectedPrinter!.typePrinter);
      }
    }

    selectedPrinter = device;
    setState(() {});
  }

  Future printReceiveTest(List<int> printTxt, Generator? generator) async {
    // List<int> bytes = [];
    //
    // // Xprinter XP-N160I
    // final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // // PaperSize.mm80 or PaperSize.mm58
    // final generator = Generator(PaperSize.mm80, profile);
    // bytes += generator.setGlobalCodeTable('CP1252');

    // if(printTxt==[]){
    //   DateTime now = DateTime.now();
    //   bytes += generator.text(DateFormat('kk:mm:ss , EEE d MMM').format(now) + "\n");
    //   bytes += generator.text("\n");
    //   bytes += generator.text("                   MEALSMASH TEST                \n");
    //   bytes += generator.text("\n");
    // }else{
    //   // bytes += generator.text(printTxt);
    // }
    // bytes += generator.text('Test Print', styles: const PosStyles(align: PosAlign.center));
    printEscPos(printTxt, generator!);



  }

  /// print ticket
  void printEscPos(List<int> printTxt, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:

        printTxt += generator.feed(2);
        printTxt += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
                name: bluetoothPrinter.deviceName,
                productId: bluetoothPrinter.productId,
                vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        printTxt += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(
                name: bluetoothPrinter.deviceName,
                address: bluetoothPrinter.address!,
                isBle: bluetoothPrinter.isBle ?? false,
                autoConnect: _reconnect));
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = printTxt;
        break;
      case PrinterType.network:
        printTxt += generator.feed(2);
        printTxt += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        await printerManager.send(type: bluetoothPrinter.typePrinter, bytes: printTxt);
        pendingTask = null;
      }
    } else {
      await printerManager.send(type: bluetoothPrinter.typePrinter, bytes: printTxt);
    }
  }

  // conectar dispositivo
  _connectDevice() async {
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(
                name: selectedPrinter!.deviceName,
                productId: selectedPrinter!.productId,
                vendorId: selectedPrinter!.vendorId));
        _isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(
                name: selectedPrinter!.deviceName,
                address: selectedPrinter!.address!,
                isBle: selectedPrinter!.isBle ?? false,
                autoConnect: _reconnect));
        break;
      case PrinterType.network:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        _isConnected = true;
        break;
      default:
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 20.sp,
                      color: BasicColors.getBlackWhiteColor())),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        // height: double.infinity,
        // constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 7.h,
                  width: MediaQuery.of(context).size.width / 10.w,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset(
                      "assets/logo.png",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              DropdownButtonFormField(
                dropdownColor:  BasicColors.primaryColor,
                value: _selectedpaper,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.insert_page_break,
                    size: 20.sp,
                    color: BasicColors.primaryColor,
                  ),
                  labelText: "Paper size",
                  labelStyle: TextStyle(
                      fontSize: 18.0.sp, color: BasicColors.primaryColor),
                  // focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: BasicColors.primaryColor, width: 2.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0.sp),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: BasicColors.primaryColor, width: 2.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0.sp),
                    ),
                  ),
                ),
                items:Papersize
                    .map((String val) {
                  return DropdownMenuItem(

                    value: val,
                    child: Text(
                      val,
                      style:TextStyle(fontSize:20.sp,color: BasicColors.getBlackWhiteColor()),
                    ),
                  );
                }).toList(),

                onChanged: (value)async {
                  setState(()  {
                    _selectedpaper = value.toString();

                    // print("papersizeee${paper}");
                  });
                  pref = await SharedPreferences.getInstance();

                  var paper = _selectedpaper;
                  pref.setString('paper', paper);
                },
                onSaved: (value)async {
                  setState(()  {
                    _selectedpaper = value.toString();

                    // print("papersizeee${paper}");
                  });
                  pref = await SharedPreferences.getInstance();

                  var paper = _selectedpaper;
                  pref.setString('paper', paper);
                },
                validator: ( value) {
                  if (value==null) {
                    return "can't empty";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              DropdownButtonFormField<PrinterType>(
                dropdownColor:  BasicColors.primaryColor,
                value: defaultPrinterType,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.print,
                    size: 20.sp,
                    color: BasicColors.primaryColor,
                  ),
                  labelText: "Type Printer Device",
                  labelStyle: TextStyle(
                      fontSize: 18.0.sp, color: BasicColors.primaryColor),
                  // focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: BasicColors.primaryColor, width: 2.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0.sp),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: BasicColors.primaryColor, width: 2.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0.sp),
                    ),
                  ),
                ),
                items: <DropdownMenuItem<PrinterType>>[
                  if (Platform.isAndroid || Platform.isIOS)
                     DropdownMenuItem(
                      value: PrinterType.bluetooth,
                      child:  Text(
                        "Bluetooth",
                        style: TextStyle(fontSize: 18.sp,color: BasicColors.getBlackWhiteColor()),
                      ),
                    ),
                  if (Platform.isAndroid || Platform.isWindows)
                     DropdownMenuItem(
                      value: PrinterType.usb,
                      child: Text(
                        "Usb",
                        style: TextStyle(fontSize: 18.0.sp,color: BasicColors.getBlackWhiteColor()),
                      ),
                    ),
                   DropdownMenuItem(
                    value: PrinterType.network,
                    child: Text(
                      "Wifi",
                      style: TextStyle(fontSize: 18.sp,color: BasicColors.getBlackWhiteColor()),
                    ),
                  ),
                ],
                onChanged: (PrinterType? value) {
                  setState(() {
                    if (value != null) {
                      setState(() {
                        defaultPrinterType = value;
                        selectedPrinter = null;
                        _isBle = false;
                        _isConnected = false;
                        _scan();
                      });
                    }
                  });
                },
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.bluetooth &&
                    Platform.isAndroid,
                child: SwitchListTile.adaptive(
                  activeColor: BasicColors.primaryColor,
                  contentPadding:
                  const EdgeInsets.only(bottom: 8.0, left: 16, top: 16),
                  title:  Text(
                    "This device supports ble (low energy)",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0.sp,color: BasicColors.getBlackWhiteColor()),
                  ),
                  value: _isBle,
                  onChanged: (bool? value) {
                    setState(() {
                      _isBle = value ?? false;
                      _isConnected = false;
                      selectedPrinter = null;
                      _scan();
                    });
                  },
                ),
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.bluetooth &&
                    Platform.isAndroid,
                child: SwitchListTile.adaptive(
                  activeColor: BasicColors.primaryColor,
                  contentPadding:  EdgeInsets.only(left: 16.sp),
                  title:  Text(
                    "Reconnect",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18.0.sp,color: BasicColors.getBlackWhiteColor()),
                  ),
                  value: _reconnect,
                  onChanged: (bool? value) {
                    setState(() {
                      _reconnect = value ?? false;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.sp),
                child: Column(
                    children: devices
                        .map(
                          (device) => ListTile(
                        title: Text(
                          '${device.deviceName}',
                          style: TextStyle(fontSize: 10.sp,color: BasicColors.getBlackWhiteColor()),
                        ),
                        subtitle: Platform.isAndroid &&
                            defaultPrinterType == PrinterType.usb
                            ? null
                            : Visibility(
                            visible: !Platform.isWindows,
                            child: Text("${device.address}",style:TextStyle(color: BasicColors.getBlackWhiteColor()),)),
                        onTap: () {
                          // do something
                          selectDevice(device);
                        },
                        leading:
                        selectedPrinter != null && ((device.typePrinter == PrinterType.usb &&
                                Platform.isWindows
                                ? device.deviceName == selectedPrinter!.deviceName : device.vendorId != null && selectedPrinter!.vendorId ==
                            device.vendorId) ||
                                (device.address != null &&
                                    selectedPrinter!.address ==
                                        device.address))
                            ?  Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 20.sp,
                        )
                            : null,
                        trailing: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1.0.w,
                                color: BasicColors.primaryColor),
                          ),
                          onPressed: selectedPrinter == null ||
                              device.deviceName !=
                                  selectedPrinter?.deviceName
                              ? null
                              : () async {
                            List<int> bytes = [];

 if(_selectedpaper=='80mm')
 {
   // print("80mmm printinggg");
   // Xprinter XP-N160I
   final profile = await CapabilityProfile.load(name: 'XP-N160I');
   // PaperSize.mm80 or PaperSize.mm58
   final generator = Generator(PaperSize.mm80, profile);
   bytes += generator.setGlobalCodeTable('CP1252');
   DateTime now = DateTime.now();
   bytes += generator.text(
       DateFormat('kk:mm:ss , EEE d MMM').format(now),
       styles: PosStyles(align: PosAlign.center));
   bytes+=generator.text("");
   bytes += generator.text("Test Print\n",
       styles: PosStyles(
           height: PosTextSize.size2,
           width: PosTextSize.size2,
           align: PosAlign.center,
           bold: true));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Invoice# : Test      ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text("Invoice# : $invoiceId     ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Payment Status: Test  ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text(
   //     "Payment Status: ${paymentStatus == '0' ? "Pending" : 'Paid'} ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Payment Method: Test  ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text("Payment Method : ${paymentMethod}  ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Order-Type: Test ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text("Order-Type: $orderTypeStatus ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Table Name: Test \n",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // if (tableName != null && tableName != "") {
   //   printTxt += generator!.text("Table Name: $tableName \n",
   //       styles: PosStyles(align: PosAlign.left));
   // }


   // bytes += generator.row([
   //   PosColumn(
   //     text: '          ',
   //     width: 1,
   //     styles: PosStyles(
   //       align: PosAlign.left,
   //     ),
   //   ),
   //   PosColumn(
   //     text: "\n",
   //     width: 10,
   //     styles: PosStyles(
   //       align: PosAlign.right,
   //     ),
   //   ),
   //   PosColumn(
   //     text: '          ',
   //     width: 1,
   //     styles: PosStyles(
   //       align: PosAlign.left,
   //     ),
   //   ),
   // ]);

   // if (tableName == null && tableName == "") {
   //   printTxt += generator!.text("\n");
   // }

   bytes += generator.text("Sale Receipt",
       styles: PosStyles(
           height: PosTextSize.size2,
           width: PosTextSize.size2,
           align: PosAlign.center,
           bold: true));
   // printTxt+=generator!.text("\n");
   bytes += generator.row([
     PosColumn(
       text: '              ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '             ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "ITEMS   ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '           ',
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: 'TOTAL',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: '       ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '           ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   // printTxt +=
   //     generator!.text("----------------------------------------");
   // printTxt+=generator!.text("\n");


   bytes += generator.row([
     PosColumn(
       text: '        ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Test Item",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '       ',
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   // printTxt+=generator!.text("${orderMeta[i].products!.title} ",styles: PosStyles(align: PosAlign.left)) +
   //
   // generator!.text( " \$ ${orderMeta[i].products!.price!.price.toString()} \n",styles: PosStyles(align: PosAlign.right));


   // printTxt += generator!.text(
   //     "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice}"
   //     // "\$ ${orderMeta[i].products!.price!.price.toString()}"
   //     " x ${orderMeta[i].qty.toString()}");
   // printTxt+=generator!.text("\n");


   // printTxt+=generator!.text("\n");
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Subtotal",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: "          ",
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Discount",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: "          ",
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Tax",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: "          ",
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Net Paid ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: "          ",
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);


   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Cash Received",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: "          ",
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);


   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Change",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '\$ 0.00',
       width: 2,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     PosColumn(
       text: "          \n",
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   printReceiveTest(bytes, generator);
 }

 else
 {
   // print("58mmm printinggg");

   // Xprinter XP-N160I
   final profile = await CapabilityProfile.load(name: 'XP-N160I');
   // PaperSize.mm80 or PaperSize.mm58
   final generator = Generator(PaperSize.mm58, profile);
   bytes += generator.setGlobalCodeTable('CP1252');
   DateTime now = DateTime.now();
   bytes += generator.text(
       DateFormat('kk:mm:ss , EEE d MMM').format(now),
       styles: PosStyles(align: PosAlign.center));
   bytes+=generator.text("");
   bytes += generator.text("Test Print  ",
       styles: PosStyles(
           height: PosTextSize.size2,
           width: PosTextSize.size2,
           align: PosAlign.center,
           bold: true));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Invoice# : Test      ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text("Invoice# : $invoiceId     ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Payment Status: Test  ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text(
   //     "Payment Status: ${paymentStatus == '0' ? "Pending" : 'Paid'} ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Payment Method: Test  ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text("Payment Method : ${paymentMethod}  ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Order-Type: Test ",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   // printTxt += generator!.text("Order-Type: $orderTypeStatus ",
   //     styles: PosStyles(align: PosAlign.left));

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Table Name: Test \n",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);



   // if (tableName == null && tableName == "") {
   //   printTxt += generator!.text("\n");
   // }

   bytes += generator.text("Sale Receipt",
       styles: PosStyles(
           height: PosTextSize.size2,
           width: PosTextSize.size2,
           align: PosAlign.center,
           bold: true));
   // printTxt+=generator!.text("\n");
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "--------------------------------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.center,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '           ',
       width: 1,
       // styles: PosStyles(
       //   align: PosAlign.left,
       // ),
     ),
     PosColumn(
       text: "ITEMS                          ",
       width: 4,
       // styles: PosStyles(
       //   align: PosAlign.left,
       // ),
     ),
     PosColumn(
       text: '                        ',
       width: 4,
       // styles: PosStyles(
       //   align: PosAlign.center,
       // ),
     ),
     PosColumn(
       text: ' TOTAL',
       width: 3,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     //   PosColumn(
     //     text: '          ',
     //     width: 1,
     //     // styles: PosStyles(
     //     //   align: PosAlign.right,
     //     // ),
     //   ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       // styles: PosStyles(
       //   align: PosAlign.left,
       // ),
     ),
     PosColumn(
       text: "----------------------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.center,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
   ]);
   // printTxt +=
   //     generator!.text("----------------------------------------");
   // printTxt+=generator!.text("\n");



     bytes += generator.row([
       PosColumn(
         text: '        ',
         width: 1,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: "Test Item               ",
         width: 4,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: '                  ',
         width: 4,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: ' \$ 0.00',
         width: 3,
         styles: PosStyles(
           align: PosAlign.right,
         ),
       ),
       // PosColumn(
       //   text: '            ',
       //   width: 1,
       //   styles: PosStyles(
       //     align: PosAlign.left,
       //   ),
       // ),
     ]);
     // printTxt+=generator!.text("${orderMeta[i].products!.title} ",styles: PosStyles(align: PosAlign.left)) +
     //
     // generator!.text( " \$ ${orderMeta[i].products!.price!.price.toString()} \n",styles: PosStyles(align: PosAlign.right));




     // printTxt += generator!.text(
     //     "\$ ${(orderMeta[i].variantPrice != null ? int.parse(orderMeta[i].variantPrice!) : variantPrices) + (orderMeta[i].products!.total != null ? int.parse(orderMeta[i].products!.total!) : 0) + extraPrice}"
     //     // "\$ ${orderMeta[i].products!.price!.price.toString()}"
     //     " x ${orderMeta[i].qty.toString()}");
     // printTxt+=generator!.text("\n");


   // printTxt+=generator!.text("\n");
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   bytes += generator.row([
     PosColumn(
       text: '            ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Subtotal         ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "             ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: ' \$ 0.00',
       width: 3,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     // PosColumn(
     //   text: "          ",
     //   width: 1,
     //   styles: PosStyles(
     //     align: PosAlign.left,
     //   ),
     // ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Discount       ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "               ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: ' \$ 0.00',
       width: 3,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     // PosColumn(
     //   text: "          ",
     //   width: 1,
     //   styles: PosStyles(
     //     align: PosAlign.left,
     //   ),
     // ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Tax              " ,
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "                ",
       width: 4,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: ' \$ 0.00',
       width: 3,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     // PosColumn(
     //   text: "          ",
     //   width: 1,
     //   styles: PosStyles(
     //     align: PosAlign.left,
     //   ),
     // ),
   ]);
   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);

   bytes += generator.row([
     PosColumn(
       text: '          ',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "Net Paid         ",
       width: 5,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "               ",
       width: 3,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: '  \$ 0.00',
       width: 3,
       styles: PosStyles(
         align: PosAlign.right,
       ),
     ),
     // PosColumn(
     //   text: "          ",
     //   width: 1,
     //   styles: PosStyles(
     //     align: PosAlign.left,
     //   ),
     // ),
   ]);

   bytes += generator.row([
     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
     PosColumn(
       text: "---------------------------------------------------------",
       width: 10,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),

     PosColumn(
       text: '',
       width: 1,
       styles: PosStyles(
         align: PosAlign.left,
       ),
     ),
   ]);


     bytes += generator.row([
       PosColumn(
         text: '          ',
         width: 1,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: "Cash Received    ",
         width: 6,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: "               ",
         width:2,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: '  \$ 0.00',
         width: 3,
         styles: PosStyles(
           align: PosAlign.right,
         ),
       ),
       // PosColumn(
       //   text: "          ",
       //   width: 1,
       //   styles: PosStyles(
       //     align: PosAlign.left,
       //   ),
       // ),
     ]);



   bytes += generator.row([
       PosColumn(
         text: '          ',
         width: 1,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: "Change       ",
         width: 4,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: "             ",
         width: 4,
         styles: PosStyles(
           align: PosAlign.left,
         ),
       ),
       PosColumn(
         text: ' \$ 0.00',
         width: 3,
         styles: PosStyles(
           align: PosAlign.right,
         ),
       ),
       // PosColumn(
       //   text: "          \n",
       //   width: 1,
       //   styles: PosStyles(
       //     align: PosAlign.left,
       //   ),
       // ),
     ]);

   bytes += generator.qrcode("12345", size: QRSize.Size6);

   printReceiveTest(bytes, generator);
 }

                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Text(
                              "Print test ticket",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: BasicColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList()),
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.network &&
                    Platform.isWindows,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _ipController,
                    keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                      label: Text(
                        "Ip Address",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                      prefixIcon: Icon(
                        Icons.wifi,
                        size: 30.sp,
                        color: BasicColors.primaryColor,
                      ),
                    ),
                    onChanged: setIpAddress,
                  ),
                ),
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.network &&
                    Platform.isWindows,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _portController,
                    keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                      label: Text(
                        "Port",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                      prefixIcon: Icon(
                        Icons.numbers_outlined,
                        size: 30.sp,
                        color: BasicColors.primaryColor,
                      ),
                    ),
                    onChanged: setPort,
                  ),
                ),
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.network &&
                    Platform.isWindows,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0.w, color: BasicColors.primaryColor),
                    ),
                    onPressed: () async {
                      if (_ipController.text.isNotEmpty)
                        setIpAddress(_ipController.text);
                      printReceiveTest([],null);
                    },
                    child:  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                      child: Text(
                        "Print test ticket",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.sp,color: BasicColors.getBlackWhiteColor()),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                            BasicColors.primaryColor, // Background color
                          ),
                          onPressed: selectedPrinter == null || _isConnected ? null
                              : () {
                            _connectDevice();
                          },
                          child: Text("Connect",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 18.sp,color: BasicColors.getBlackWhiteColor())),
                        ),
                      ),
                    ),
                     SizedBox(width: 8.sp),
                    Expanded(
                      child: Container(
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                            BasicColors.primaryColor, // Background color
                          ),
                          onPressed: selectedPrinter == null || !_isConnected
                              ? null
                              : () {
                            if (selectedPrinter != null)
                              printerManager.disconnect(
                                  type: selectedPrinter!.typePrinter);
                            setState(() {
                              _isConnected = false;
                            });
                          },
                          child: Text("Disconnect",
                              textAlign: TextAlign.center,
                              style:
                              Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 18.sp,color: BasicColors.getBlackWhiteColor(),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  get reconnect => _reconnect;

  get isConnected => _isConnected;

  StreamSubscription<PrinterDevice>? get subscription => _subscription;

  StreamSubscription<BTStatus>? get subscriptionBtStatus => _subscriptionBtStatus;

  StreamSubscription<USBStatus>? get subscriptionUsbStatus => _subscriptionUsbStatus;

  BTStatus get currentStatus => _currentStatus;

  USBStatus get currentUsbStatus => _currentUsbStatus;

  String get ipAddress => _ipAddress;

  String get port => _port;

  get ipController => _ipController;

  get portController => _portController;


}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter(
      {this.deviceName,
        this.address,
        this.port,
        this.state,
        this.vendorId,
        this.productId,
        this.typePrinter = PrinterType.bluetooth,
        this.isBle = false});
}
