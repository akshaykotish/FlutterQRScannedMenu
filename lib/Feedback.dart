import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/home.dart';

import 'button.dart';

class feedback extends StatefulWidget {

  String Shop_Contact;

  feedback({this.Shop_Contact});

  @override
  _feedbackState createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {

  TextEditingController feedcontroller = new TextEditingController();


  String Generate_Shop_Id(){
    var datetime = DateTime.now();
    String fid = datetime.millisecond.toString() + datetime.second.toString() + datetime.minute.toString() + datetime.hour.toString();
  return fid;
  }

  Future<void> Save_Feedback()
  async {
    String datetiem  =DateTime.now().toString();
    print(datetiem);
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.Shop_Contact + "/Feedbacks/" + Generate_Shop_Id()).set({
      "message":feedcontroller.text,
      "Time":datetiem
    });
    Navigator.pop(context);
    home();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset("Assets/logo.png"),
                padding: EdgeInsets.only(
                  top: 150,
                  left: 80,
                  right: 80,
                  bottom: 30,
                ),
              ),
              SizedBox(height: 40,),
              Text("Your order is under process.", style: TextStyle(color: Colors.white, fontSize: 20),),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You can feedback.", style: TextStyle(color: Colors.white, fontSize: 20),),
                 // Text(widget.Shop_Name.toString(), style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: txtfld(
                  labeltext: "Your Feedback",
                  FieldController: feedcontroller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 60,
                  right: 60,
                  top: 20,
                  bottom: 20,
                ),
                child: button(
                  Button_Name: "Submit",
                  Click: Save_Feedback,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
