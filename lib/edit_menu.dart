import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:scanapp/Create_Menu.dart';
import 'package:scanapp/ShowMenu.dart';

import 'add_menu.dart';

class editmenu extends StatefulWidget {

  String Contact = "";
  String Item_Name = "";
  String Item_Details = "";
  double Item_Price = 0.0;
  String Item_Image = "";
  bool Item_veg = false;
  bool Item_glu = false;
  bool Item_egg = false;
  String Category;
  editmenu({this.Category, this.Contact, this.Item_Name, this.Item_Details, this.Item_Image, this.Item_Price, this.Item_egg, this.Item_glu, this.Item_veg});

  @override
  _editmenuState createState() => _editmenuState();
}

class _editmenuState extends State<editmenu> {

  void Delete(){
    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Shops/"+ widget.Contact +"/Menu/" + widget.Category + "/" + widget.Item_Name).remove();

    Toast.show("Item deleted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>addmenu(
              name: widget.Item_Name,
              details: widget.Item_Details,
              image: widget.Item_Image,
              price: widget.Item_Price,
              vegtrian: widget.Item_veg,
              gluten: widget.Item_glu,
              egg: widget.Item_egg,
              title: "Edit Product",
            )));
          }),
          IconButton(icon: Icon(Icons.delete), onPressed: Delete),
        ],
      ),
    );
  }
}
