import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/superadmin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'button.dart';
import 'home.dart';

class adminlogin extends StatefulWidget {

  String name;
  String phone;

  adminlogin({this.name, this.phone});

  @override
  _adminloginState createState() => _adminloginState();
}

class _adminloginState extends State<adminlogin> {


  TextEditingController adminlogincontroller = new TextEditingController();
  String erroradminlogin = null;

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
        await Save_Pref();
      }
      else{

      }
    });
  }
  void Failed(FirebaseAuthException e){
    print("Error " + e.toString());
  }

  void adminlogin_Send(String vid, int token){
    VerfiID = vid;
  }

  _verifyphone() async{
    print("Sending adminlogin");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: Verified,
        verificationFailed: Failed,
        codeSent: adminlogin_Send,
        codeAutoRetrievalTimeout: (String vid){
          VerfiID  = vid;
        }, timeout: Duration(seconds: 60));

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

  void Verify(){
    Read_Pin().then((value){
      if(my_code == value)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => superadmin()));
        }
    });
  }

  Future<void> running() async {
  }

  @override
  void initState(){
    super.initState();
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
                      "Login Admin PIN",
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
                          controller: adminlogincontroller,
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
                            labelText: "One Time Pin (adminlogin)",
                            hintText: "One Time Pin (adminlogin)",
                            errorText: erroradminlogin,
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
                                fontFamily: "ariel", fontSize: 20, color: Colors.white),
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

                      ],
                    ),
                  )
                ],
              ),
            ),
            button(
              Button_Name: "Login",
              Click: Verify,
            )
          ],
        ),
      ),
    );
  }
}
