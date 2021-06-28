import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ColorCode.dart';
import 'button.dart';

class txtfld extends StatefulWidget {
  String hinttext = "";
  String labeltext = "";
  String errortext = "";
  String prefixtext = "";
  int len;
  var FieldController = TextEditingController();
  Icon icon = Icon(Icons.edit);
  TextInputType textInputType;

  Function function_controller = (text)=>{

  };

  txtfld({this.hinttext, this.labeltext, this.errortext, this.function_controller, this.textInputType, this.FieldController, this.icon, this.prefixtext, this.len});

  @override
  _txtfldState createState() => _txtfldState();
}

class _txtfldState extends State<txtfld> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            focusNode: FocusNode(),
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.len),
            ],
            style: TextStyle(
              fontFamily: "ariel",
              color: Colors.white,
            ),
            onChanged: widget.function_controller,
            decoration: new InputDecoration(
              prefixIcon: IconTheme(
                data: IconThemeData(
                  color: GetColorFromHex("#DEDEDE"),
                ),
                child: widget.icon != null ? widget.icon : Icon(Icons.edit),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              border: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),

              prefixText: widget.prefixtext,
              errorText: widget.errortext,
              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontFamily: "ariel",
                color: GetColorFromHex("#DEDEDE"),
              ),
              hintText: widget.hinttext,
              hintStyle: TextStyle(
                fontFamily: "ariel",
                color: Colors.white,
              ),

            ),
            controller: widget.FieldController,
            keyboardType: widget.textInputType,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),

          ),
        ],
      ),
    );
  }
}
