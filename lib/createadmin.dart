import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';

import 'button.dart';

class createadmin extends StatefulWidget {
  @override
  _createadminState createState() => _createadminState();
}

class _createadminState extends State<createadmin> {

  TextEditingController _name = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  String name = "";
  String phone = "";

  String error_name = null;
  String error_phone = null;

  void Send_OTP(){

  }

  Future<String> Read_Pin()
  async {
    var pin = "";
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Admin").once().then((DataSnapshot dataSnapShot) {
      pin = dataSnapShot.value;
      print(pin);
    });
    return pin;
  }

  Future<void> Save() async {
    phone = _phone.text;
    name = _name.text;
    Read_Pin().then((pin_value){
      print("Pin is " + pin_value);
      if(name != "" && phone != "" && pin_value != "" && pin_value == name && phone.length == 6) {
        final DBRef = FirebaseDatabase.instance.reference();
        DBRef.child("Admin").set(phone);

        Toast.show("Pin Changed!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

        Navigator.pop(context);
      }
      else{

        Toast.show("Invalid Pin", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

        if(name == "") {
          error_name = "Please enter valid current pin.";
        }
        else{
          error_name = null;
        }
        if(phone == "") {
          error_name = "Please enter valid new pin.";
        }
        else{
          phone = null;
        }
        setState(() {

        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
              height: MediaQuery.of(context).size.height - 70,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 120,
                      left: 60,
                      right: 60,
                      bottom: 40,
                    ),
                    child: Image.asset("Assets/logo.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "Change Admin Pin",
                      style: TextStyle(
                          fontFamily: "ariel",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          obscureText: true,
                          obscuringCharacter: "#",
                          controller: _name,
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            labelText: "Current Pin",
                            hintText: "Current Pin",
                            errorText: error_name,
                            labelStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(Icons.fiber_pin, color: Colors.white,),

                          ),
                          style: TextStyle(
                            fontFamily: "ariel",
                            color: Colors.white,
                          ),
                          maxLength: 6,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          obscureText: true,
                          obscuringCharacter: "#",
                          controller: _phone,
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            enabledBorder:  OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                            ),
                            labelText: "New Pin",
                            hintText: "New Pin",
                            errorText: error_phone,
                            labelStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            prefixText: "",
                            prefixIcon: Icon(Icons.fiber_pin, color: Colors.white,),
                          ),
                          style: TextStyle(
                            fontFamily: "ariel",
                            color: Colors.white,
                          ),
                          maxLength: 6,
                          keyboardType: TextInputType.phone,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            button(
              Button_Name: "Save Pin",
              Click: Save,
            )
          ],
        ),
      ),
    );
  }
}
