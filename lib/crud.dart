import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class CRUD extends StatefulWidget {
  @override
  _CRUDState createState() => _CRUDState();
}

class _CRUDState extends State<CRUD> {


  Color color = Colors.yellow;
  Map data;
  final DBRef = FirebaseDatabase.instance.reference();
  var code = "Data";

  void Write_Data() {
    DBRef.child("Shops").child("Menu").set({
      "id":"item1",
      "name":"Sample Food"
    }).asStream();
    setState(() {
      color = Colors.white;
    });
  }

  void Read_Data() async{
    var data;
    DBRef.once().then((DataSnapshot dataSnapshot){
      data = dataSnapshot.value;

      Map<dynamic, dynamic> Shops = jsonDecode(data);
      for(int i=0; i<Shops.length; i++)
        {
          Map<dynamic, dynamic> Menu = jsonDecode(Shops[i]["Menu"]);
          for(int j=0; j<Menu.length; j++)
            {
                print(Menu[j]["name"]);
            }
        }
      //print(dataSnapshot.value);
    });
  }

  void Read_Shop_Menu(){
      var ref = FirebaseDatabase.instance.reference().child("Shops/Menu");
      ref.once().then((DataSnapshot datasnapshot){
        print(datasnapshot.value);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
            child: FlatButton(
                    color: color,
                    child: Text(code),
                    onPressed:  Read_Shop_Menu,
                    ),
            ),
      ),
    );
  }
}
