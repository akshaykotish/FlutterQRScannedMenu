import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanapp/ColorCode.dart';
import 'package:scanapp/OrderData.dart';
import 'package:scanapp/edit_menu.dart';

import 'TextFld.dart';

class content extends StatefulWidget {
  String Name = "";
  String Contact = "";
bool veg = false;
bool gluten = false;
bool egg = false;
String details = "";
double price = 0.0;
String image = "";
bool show_edit = true;
OrderData orderData;
String category;

  content({this.category, this.Name, this.veg, this.details, this.price, this.image, this.show_edit, this.Contact, this.gluten, this.egg, this.orderData});

  @override
  _contentState createState() => _contentState();
}

class _contentState extends State<content> {

  Function onClick(){

  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

    Uint8List imagebytes;

  var quantity = 0;

  void Save_Item(){
    widget.orderData.Add_New(widget.Name, quantity, double.parse(widget.price.toString()), (double.parse(widget.price.toString()) * quantity));
  }

  void Increase_qty()
  {
    quantity = quantity + 1;
    Save_Item();
    setState(() {

    });
  }
  void Decrease_qty()
  {
    quantity = quantity - 1;
    Save_Item();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

  if(widget.image != null) {

    Uint8List _imagebytes = base64Decode(widget.image);
    setState(() {
      imagebytes = _imagebytes;
    });
  }



    return GestureDetector(


      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        child: Image.memory(
                          imagebytes,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20 - 100,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    width: 200,
                                  padding: const EdgeInsets.all(15),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            widget.Name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: "ariel",
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            height: 15,
                                            child: Image.network(widget.veg == true ? "https://www.pngkey.com/png/full/261-2619381_chitr-veg-symbol-svg-veg-and-non-veg.png" : "https://www.pngkey.com/png/full/245-2459071_non-veg-icon-non-veg-symbol-png.png"),
                                          )
                                        ],
                                      ),
                                      Text(
                                       widget.details.substring(0, widget.details.length < 80 ? widget.details.length : 80) + "...",
                                        style: TextStyle(
                                          fontFamily: "ariel",
                                          fontSize: 11,
                                          color: Colors.black,
                                        ),),
                                    ],
                                  )
                                ),
                                Container(
                                  child: Align(
                                    child: Text(
                                      "₹ " + widget.price.toString(),
                                      style: TextStyle(
                                        fontFamily: "ariel",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: widget.show_edit == true ?editmenu(
                                  Contact: widget.Contact,
                                  Item_Name: widget.Name,
                                  Item_Price: widget.price,
                                  Item_Details: widget.details,
                                  Item_Image:  widget.image,
                                  Item_egg: widget.egg,
                                  Item_glu: widget.gluten,
                                  Item_veg:widget.veg,
                                Category: widget.category,
                              ):
                              Container(
                                width: 250,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end
                                  ,
                                  children: <Widget>[
                                    FlatButton(
                                      color: GetColorFromHex("#F5F5F5"),
                                      minWidth: 20,
                                        onPressed: Decrease_qty,
                                        child: Icon(Icons.remove)),
                                    Container(
                                      color: GetColorFromHex("#F5F5F5"),
                                      height: 35,
                                      alignment: Alignment.center,
                                      child: Text(quantity.toString(),
                                      style: TextStyle(
                                        backgroundColor: GetColorFromHex("#F5F5F5"),
                                      ),),
                                    ),
                                    FlatButton(
                                        color: GetColorFromHex("#F5F5F5"),
                                        minWidth:20,
                                        onPressed: Increase_qty,
                                        child: Icon(Icons.add)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
