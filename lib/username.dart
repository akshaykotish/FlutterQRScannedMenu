import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/content.dart';
import 'package:scanapp/otp.dart';

import 'button.dart';

class username extends StatefulWidget {
  @override
  _usernameState createState() => _usernameState();
}

class _usernameState extends State<username> {

  TextEditingController _name = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  String name = "";
  String phone = "";

  String error_name = null;
  String error_phone = null;

void Send_OTP(){

}



Future<void> Save() async {
  phone = _phone.text;
  name = _name.text;

  if(name != "" && phone != "" && phone.length == 10) {
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Users").child(phone).set({
      "Name" : name,
      "Phone" : phone,
      "Active" : "Y"
    });

    Navigator.push(context, MaterialPageRoute(builder: (content) => otp(
      name: name,
      phone: phone,
    )));
  }
  else{
    if(name == "") {
      error_name = "Please enter full name.";
    }
    else{
      error_name = null;
    }
    if(phone == "" || phone.length < 10) {
      error_name = "Please enter valid phone number.";
    }
    else{
      phone = null;
    }
    setState(() {

    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      "Sign in",
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
                            labelText: "Full Name",
                            hintText: "Full Name",
                            errorText: error_name,
                            labelStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(Icons.account_box, color: Colors.white,),

                          ),
                          style: TextStyle(
                            fontFamily: "ariel",
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
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
                            labelText: "Phone",
                            hintText: "Phone",
                            errorText: error_phone,
                            labelStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                            ),
                            prefixText: "+91 ",
                            prefixIcon: Icon(Icons.phone, color: Colors.white,),
                          ),
                          style: TextStyle(
                            fontFamily: "ariel",
                            color: Colors.white,
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            button(
              Button_Name: "Continue",
              Click: Save,
            )
          ],
        ),
      ),
    );
  }
}
