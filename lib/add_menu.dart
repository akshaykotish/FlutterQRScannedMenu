import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/switch.dart';

import 'TextFld.dart';
import 'background.dart';
import 'button.dart';

import 'package:image_picker/image_picker.dart';

class addmenu extends StatefulWidget {




  String title = "";
  String name = "";
  String details = "";
  double price = 0.00;
  bool vegtrian = false;
  bool gluten = false;
  bool egg = false;
  String image = "";
  String contact = "";

  String error_name;
  String error_details;
  String error_price;
  String error_veg;
  String error_image;


  addmenu({this.name, this.details, this.price, this.vegtrian, this.image, this.contact, this.title, this.gluten, this.egg});

  @override
  _addmenuState createState() => _addmenuState();
}

class _addmenuState extends State<addmenu> {


  String _value = "";

  TextEditingController textEditingController= TextEditingController();

  String message = "";

  var All_Catgs = <DropdownMenuItem>[];

  void Load_Category(){

    var _All_Catgs = <DropdownMenuItem>[];

    final DBRef = FirebaseDatabase.instance.reference();

    DBRef.child("Shops/"+ widget.contact +"/Menu").once().then((DataSnapshot dataSnapShot)
    {
      //print(dataSnapShot.value);
      if(dataSnapShot.value != null) {
        var keys = dataSnapShot.value.keys;
        var values = dataSnapShot.value;

        int itemvalue = 1;
        for(var key in keys)
        {
          if(itemvalue == 1)
            {
              _value = key.toString();
            }
          _All_Catgs.add(
              new DropdownMenuItem(child: Text(key.toString()), value: key.toString(),)
          );
          itemvalue++;
        }

        setState(() {
          All_Catgs = _All_Catgs;
        });
      }
    });
  }

  Future<void> Save_Catgory() async {
    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.contact);
    await DBRef.child("Shops/" + widget.contact.toString() + "/Menu/" + textEditingController.text).set("");
    Load_Category();
    message = "Saved!";
  }

  bool sts_v= false;
  bool sts_g= false;
  bool sts_e= false;


  TextEditingController name_controller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController details_controller = new TextEditingController();

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
   else if(widget.image != "" && imagebytes != null)
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
    widget.name = name_controller.text;
    widget.details = details_controller.text;
    widget.price = double.parse(pricecontroller.text);
    String image_base64;
    if(imagebytes == null) {
      image_base64 = ConvertImagetoBase64();
    }
    else{
      image_base64 = base64Encode(imagebytes);
    }

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.contact);
    DBRef.child("Shops/" + widget.contact.toString() + "/Menu/" + _value + "/" + widget.name).set({
      "Name":widget.name,
      "Details":widget.details,
      "Price":widget.price,
      "Image":image_base64,
      "Veg":sts_v == true ? false : true,
      "Gluten":sts_g,
      "Egg":sts_e
    });
  Navigator.pop(context, "A");
  }

  void onchange_v(value){
      if(sts_v == false){
        setState(() {
          sts_v = true;
          print("=>" + sts_v.toString());
        });
      }
      else{
        setState(() {
          sts_v = false;
          print(sts_v);
        });
      }
  }

  void onchange_g(value){
    if(sts_g == false){
      setState(() {
        sts_g = true;
        print("=>" + sts_g.toString());
      });
    }
    else{
      setState(() {
        sts_g = false;
        print(sts_g);
      });
    }
  }

  void onchange_e(value){
    if(sts_e == false){
      setState(() {
        sts_e = true;
        print("=>" + sts_e.toString());
      });
    }
    else{
      setState(() {
        sts_e = false;
        print(sts_e);
      });
    }
  }


  @override
  void initState() {
    Load_Category();
    // TODO: implement initState
    super.initState();
    if (widget.name != null) {
      name_controller.text = widget.name;
    }
    if (widget.details != null) {
      details_controller.text = widget.details;
    }
    if (widget.price != null) {
      pricecontroller.text = widget.price.toString();
    }
    if(widget.gluten != null)
    {
      sts_g = widget.gluten;
    }
    if(widget.egg != null)
    {
      sts_e = widget.egg;
    }
    if(widget.vegtrian != null)
    {
      sts_v = widget.vegtrian == true ? false : true;
    }
    if (widget.image != null) {
      Uint8List _imagebytes = base64Decode(widget.image);
      setState(() {
        imagebytes = _imagebytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 70,
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50,
                        left: 70,
                        right: 70,
                        bottom: 50
                    ),
                    child: Container(
                      child : Image.asset("Assets/logo.png"),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(30),
                  child: Text(widget.title,
                  style: TextStyle(
                    fontFamily: "ariel",
                    fontSize: 25,
                    color: Colors.white,
                  ),),),
                  Container(
                    height: MediaQuery.of(context).size.height - 360,
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                              child: Column(
                                children: <Widget>[
                                  Text("Choose category", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                  DropdownButton(
                                    value: _value,
                                    style: TextStyle(color: Colors.white),
                                    dropdownColor: Colors.black,
                                    items: All_Catgs,
                                    onChanged: (value){
                                      setState(() {
                                        _value = value;
                                      });
                                    },

                                  ),
                                ],
                              ),
                            alignment: Alignment.centerLeft,
                          ),

                          txtfld(
                            hinttext: "Product Name",
                            labeltext: "Enter Product Name",
                            icon: Icon(Icons.category),
                            errortext: widget.error_name,
                            FieldController: name_controller,
                          ),
                          txtfld(
                            hinttext: "Product Details",
                            labeltext: "Enter Product Details",
                            icon: Icon(Icons.description),
                            errortext: widget.error_details,
                            FieldController: details_controller,
                          ),
                          txtfld(
                            hinttext: "Product Cost",
                            labeltext: "Enter Product Cost",
                            icon: Icon(Icons.payments_outlined),
                            prefixtext: "₹ ",
                            textInputType: TextInputType.number,
                            errortext: widget.error_name,
                            FieldController: pricecontroller,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                switchbtn(
                                  name: "Non Veg",
                                  state: sts_v,
                                  chng:onchange_v,
                                ),
                                switchbtn(
                                  name: "Gluten Free",
                                  state: sts_g,
                                  chng:onchange_g,
                                ),
                                switchbtn(
                                  name: "Include Eggs",
                                  state: sts_e,
                                  chng:onchange_e,
                                ),
                              ],
                            ),
                          ),
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

                ],
              ),
            ),
            button(
              Button_Name: "Save",
              Click: Save,
            ),
          ],
        ),
      ),
    );
  }
}