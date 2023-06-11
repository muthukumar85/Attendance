

import 'dart:convert';

import 'package:attendance/pages/QRCODESERVICE/successAttendance.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



class QRScanner extends StatefulWidget {
  const QRScanner({Key? key , required this.users}) : super(key: key);
  final User users;
  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool isCallGoogle = false;
  Barcode? result;
  QRViewController? controller;
  late User users;
  bool isWill = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    users = widget.users;
    super.initState();
  }
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (isCallGoogle) {
      return const Scaffold(
        body: Center(
          child: SpinKitThreeInOut(
            color: Colors.purple,
            size: 80,
          ),
        ),
      );
    }
    else {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (result != null)
                      Column(
                        children: [
                          Text(
                              'Barcode Type: ${describeEnum(result!
                                  .format)}   Data: ${result!.code}'),
                          RaisedButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              dispose();
                              Navigator.pop(context);
                            },
                            child: const Text('Close',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10
                              ),
                            ),
                          ),
                        ],

                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: RaisedButton(
                              color: Colors.purpleAccent,
                              onPressed: () {
                                _onQRViewCreated(controller!);
                              },
                              child: const Text('Scan Code',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: RaisedButton(
                              color: Colors.redAccent,
                              onPressed: () {
                                dispose();
                                Navigator.pop(context);
                              },
                              child: const Text('Close',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.purpleAccent,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async{
      setState(() {
        isCallGoogle = true;
      });
      // print('data scanned');
      // print(scanData);
        String results = scanData.code as String;
        Map data = {};
      try{
        Map data = await jsonDecode(results);
        bool isJoin = await UserService.PostAttendance(users: users, classdata: data, context: context , );
        // print('isJoin$isJoin');
        if(isJoin){
          await UserService.GetClassList(context: context, users: users);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>SuccessPresent(classdata: data, users: users,)
          ), (route) => false);
        }
        else{
          await IsJoinFalse(classdata: data);
          // dispose();
        }
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR Code')),
        );
        Navigator.pop(context);
      }

    });
  }
  Future<dynamic> IsJoinFalse({required Map classdata}) async {

    await showDialog(
        context: context, builder: (context) {
      return StatefulBuilder(
          builder: (context, setState)
      {
        if(isWill){
          return const AlertDialog(
            title: SpinKitCircle(color: Colors.purple,size: 100,),
          );
        }else {
          return AlertDialog(
            title:  const Text(
                'You are not jonined the class yet'),
            actions: [
              RaisedButton(
                  elevation: 2.0,
                  color: Colors.purple,
                  onPressed: () async {
                    setState(() {
                      isWill = true;
                    });
                    await UserService.JoinClassQR(users: users,
                        context: context,
                        classid: classdata['id']);
                    await UserService.PostAttendance(
                      users: users, classdata: classdata, context: context,);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>SuccessPresent(classdata: classdata, users: users,)
                    ), (route) => false);
                    // await UserService.GetClassList(
                    //     context: context, users: users);
                  },
                  child: const Text(
                    'Join', style: TextStyle(color: Colors.white),)),
              TextButton(
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                child: const Text(
                  'Cancel', style: TextStyle(color: Colors.purple),),)
            ],
          );
        }
      });
    });
  }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}