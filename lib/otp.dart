import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:toast/toast.dart';
import 'button.dart';
import 'home.dart';

class otp extends StatefulWidget {

  String name;
  String phone;

  otp({this.name, this.phone});

  @override
  _otpState createState() => _otpState();
}

class _otpState extends State<otp> {
  bool show_resend = false;

  TextEditingController otpcontroller = new TextEditingController();
  String errorotp = null;

  String _code = "";
  String my_code = "";
  String VerfiID;


  void Save_Pref() async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", widget.name);
    await prefs.setString("phone", widget.phone);
  }

  void Verified(PhoneAuthCredential cred) async{
    await FirebaseAuth.instance.signInWithCredential(cred).then((value) async{
      if(value.user != null)
        {
          print("User logged in");
          Toast.show("User logged in", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          await Save_Pref();
        }
      else{

      }
    });
  }
  void Failed(FirebaseAuthException e){
    print("Error " + e.toString());
    Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  }

  void OTP_Send(String vid, int token){
    VerfiID = vid;
  }

  _verifyphone() async{
    print("Sending OTP");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: Verified,
        verificationFailed: Failed,
        codeSent: OTP_Send,
        codeAutoRetrievalTimeout: (String vid){
          VerfiID  = vid;
        }, timeout: Duration(seconds: 120));
    show_resend = false;
    setState(() {
      show_resend = false;
    });
    Timer(Duration(seconds: 120), () {
      onEnd();
    });
  }


void onEnd() {show_resend = true;
  setState(() {
    show_resend = true;
  });
}

  void Verify(){
    FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: VerfiID, smsCode: my_code)).then((value) async {
        if(value.user != null){
          print("At Home");
          await Save_Pref();
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (content) => home()));
        }
        else{
          setState(() {
            errorotp = "Wrong OTP.";
            Toast.show("Wrong OTP", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          });
        }
    });

    //Navigator.push(context, MaterialPageRoute(builder: (content) => home()));
  }

  Future<void> running() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void initState(){
    _verifyphone();
    super.initState();
    running();
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
                      "Verify OTP",
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
                        /*
                        TextField(
                          controller: otpcontroller,
                          keyboardType: TextInputType.number,
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
                            labelText: "One Time Pin (OTP)",
                            hintText: "One Time Pin (OTP)",
                            errorText: errorotp,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(Icons.account_box, color: Colors.white,),

                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLength: 6,
                        ),*/
                        PinFieldAutoFill(
                          decoration: UnderlineDecoration(
                            textStyle: TextStyle(
                                fontFamily: "ariel",fontSize: 20, color: Colors.white),
                            colorBuilder: FixedColorBuilder(Colors.white),
                          ),
                          currentCode: _code,
                          onCodeSubmitted: (code) {
                            Verify();
                          },
                          onCodeChanged: (code) {
                            my_code = code;
                            print("Code is ===> " + my_code);
                            if (code != null && code.length == 6) {
                              Verify();
                            }
                          },
                        ),
                        SizedBox(height: 20,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Visibility(
                              visible: show_resend,
                              child: FlatButton(onPressed: (){
                                _verifyphone();

                              }, child: Row(children: <Widget>[Icon(Icons.refresh, color: Colors.white,), Text("Resend", style: TextStyle(color: Colors.white),)],

    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            button(
              Button_Name: "Verify",
              Click: Verify,
            )
          ],
        ),
      ),
    );
  }
}
