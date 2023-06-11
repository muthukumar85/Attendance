

import 'package:attendance/pages/QRCODESERVICE/qr_code_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FloatButton extends StatefulWidget{
  const FloatButton({Key? key , required this.users}) : super(key: key);
  final User users;
  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton> {
  late User users;
  @override
  void initState() {
    users = widget.users;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: FloatingActionButton(
          shape:BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => QRScanner(users: users),
            ),
            );
          },
          backgroundColor: Colors.white,
          child: const Text('Scan QR',
            style: TextStyle(
                color: Colors.purple,
                fontSize: 20
            ),
          )
      ),
    );
  }
}