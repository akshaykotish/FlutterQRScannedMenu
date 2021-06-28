import 'package:flutter/material.dart';
import 'package:scanapp/adminlogin.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/home.dart';
import 'package:scanapp/qrcode.dart';
import 'package:scanapp/superadmin.dart';
import 'package:scanapp/username.dart';

class splashscreen extends StatefulWidget {
  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(
        Duration(
          milliseconds: 500,
        ),
            (){
              Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => adminlogin()));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: backgroundGradient,
      ),
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Image.asset(
          "Assets/logo.png"
        ),

      ),
    );
  }
}
