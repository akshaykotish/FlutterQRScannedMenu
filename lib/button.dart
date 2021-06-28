import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'ColorCode.dart';


class button extends StatefulWidget {
  String Button_Name = "";
  Function Click = null;
  button({this.Button_Name, this.Click});

  @override
  _buttonState createState() => _buttonState();
}

class _buttonState extends State<button> {
  void ONPress(){
    widget.Button_Name = "Apple";
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return FlatButton(
            onPressed:widget.Click != null ? widget.Click : ONPress,
            color: GetColorFromHex('#B01A3F'),
            height: 70,
            child: Center(
              child: Text(
                widget.Button_Name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "ariel",

                ),

              ),
            ),
    );
  }
}
