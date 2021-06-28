import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';

import 'button.dart';

class category extends StatefulWidget {

  String contact;

  category({this.contact});

  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {

  int _value = 1;

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
              _All_Catgs.add(
                new DropdownMenuItem(child: Text(key.toString()), value: itemvalue,)
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Load_Category();
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
                  Container(
                    child: Image.asset("Assets/logo.png"),
                    padding: EdgeInsets.only(
                      top: 50,
                      left: 100,
                      right: 100,
                      bottom: 40
                    ),
                  ),
                  Text("Categories", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),),
                  SizedBox(height: 100,),
                  Text("View existing categories", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
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
                  SizedBox(height: 100,),
                  Text("Add new categorie", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 100,
                      right: 100,
                      bottom: 20,
                    ),
                    child: txtfld(
                      hinttext: "Enter new category",
                      labeltext: "Enter new category",
                      FieldController: textEditingController,
                      function_controller: (v){
                        message = "";
                      },
                    ),
                  ),
                  SizedBox(height: 100,),
                  Text(message, style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
            button(
              Button_Name: "Save",
              Click: Save_Catgory,
            )
          ],
        ),
      ),
    );
  }
}
