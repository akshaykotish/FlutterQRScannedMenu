import 'package:flutter/material.dart';
import 'ColorCode.dart';

class switchbtn extends StatefulWidget {
  bool state = false;
  Function chng;
  String name = "";

  switchbtn({this.state, this.chng, this.name});

  @override
  _switchbtnState createState() => _switchbtnState();
}

class _switchbtnState extends State<switchbtn> {

  Function sttchng(bool value){
    if(widget.state == true){
      setState(() {
        widget.state = false;
      });
    }
    else{
      widget.state = true;
      setState(() {
        widget.state = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Transform.scale(
          scale: 1,
          child: Switch(
            value: widget.state,
            onChanged: widget.chng != null ? widget.chng : sttchng,
            //activeColor: GetColorFromHex("#B11B40"),
            //inactiveThumbColor: GetColorFromHex("#B11B40"),
            activeColor: GetColorFromHex("#8b0000"),
            activeTrackColor: Colors.white,
            inactiveThumbColor:GetColorFromHex("#A9A9A9"),
            inactiveTrackColor: Colors.white,
        ),
        ),
        Text(widget.name,
          style: TextStyle(
              fontFamily: "ariel",
              fontSize: 12,
              color: Colors.white
          ),
        )
      ],
    );
  }
}
