import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/button.dart';

class changebanner extends StatefulWidget {

  String Shop_Name;
  String Shop_Contact;
  String Shop_Email;
  String Shop_Address;
  String Banner_Image;
  changebanner({this.Shop_Name, this.Shop_Contact, this.Shop_Email, this.Shop_Address, this.Banner_Image});

  @override
  _changebannerState createState() => _changebannerState();
}

class _changebannerState extends State<changebanner> {


  File imagefile;
  final picker = ImagePicker();

  void _openGallery(BuildContext context) async {
    imagebytes = null;
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null) {
        imagefile = File(pickedFile.path);
        setState(() {
          imagefile = File(pickedFile.path);
          LoadImage();
          Navigator.of(context).pop();
        });
      }
    });

  }

  void _openCamera(BuildContext context) async{
    imagebytes = null;
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile != null) {
        imagefile = File(pickedFile.path);
        setState(() {
          imagefile = File(pickedFile.path);
          LoadImage();
          Navigator.of(context).pop();
        });
      }
    });

  }


  Future<void> _showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context, builder: (BuildContext context)
    {
      return AlertDialog(
        title: Text("Make a Choice"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child : Text("Gallery"),
                  onTap: (){
                    _openGallery(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child : Text("Camera"),
                  onTap: (){
                    _openCamera(context);
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Uint8List imagebytes;
  Widget LoadImage(){
    if(imagefile != null)
    {
      print("=====> 1");
      return Image.file(imagefile,
        width: 400,
        height: 400,
      );
    }
    else if(imagebytes != null)
    {
      print("=====> 2");
      return Image.memory(imagebytes, width: 400, height: 400,);
    }
    else{
      print("=====> 3");
      return Text("No Image Selected.");
    }

  }

  String ConvertImagetoBase64(){
    if(imagefile != null) {
      Uint8List bytes = imagefile.readAsBytesSync();
      return base64Encode(bytes);
    }
    return "";
  }

  void Save(){
    String image_base64;
    if(imagebytes == null) {
      image_base64 = ConvertImagetoBase64();
    }
    else{
      image_base64 = base64Encode(imagebytes);
    }

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.Shop_Contact);
    DBRef.child("Shops/" + widget.Shop_Contact.toString() + "/Banner").set({
      "url":image_base64
    });
    Navigator.pop(context, "A");
  }

  Future<String> GetBanner()
  async {
    String banner = null;
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Banner").once().then((DataSnapshot dataSnapShot){
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      if(keys != null && values["url"] != null)
        {
          print(values["url"]);
          banner = values["url"].toString();
          return banner;
        }
    });
    return banner;
  }

  @override
  void initState() {
    super.initState();
    GetBanner().then((bnr){
      if(bnr != null)
      {
        Uint8List _imagebytes = base64Decode(bnr);
        setState(() {
          imagebytes = _imagebytes;
        });
      }
    });

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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 70,
                        left: 100,
                        right: 100,
                        bottom: 50,
                      ),
                      child: Image.asset("Assets/logo.png"),
                    ),
                    Text("Change Banner",
                    style: TextStyle(
                        fontFamily: 'ariel',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 50,),
                    Container(
                      padding: EdgeInsets.all(20),
                      width:MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child:
                      RaisedButton(onPressed:(){
                        _showChoiceDialog(context);
                      },
                        color: Colors.white,
                        child: Text("Click Image"),
                      ),

                    ),
                    Container(
                      child: LoadImage(),
                    )

                  ],
                ),
              ),
            ),
            button(
              Button_Name: "Save",
              Click: Save,
            )
          ],
        ),
      ),
    );
  }
}
