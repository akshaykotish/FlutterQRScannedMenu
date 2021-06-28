import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/tables.dart';

class addtables extends StatefulWidget {

  String shop_name = "NONAME";
  String shop_details;
  String shop_address;
  String shop_id = "9643108Tas";
  String shop_contact;
  String shop_email;
  String shop_active = "Y";

  addtables({this.shop_name, this.shop_details, this.shop_address, this.shop_email, this.shop_contact, this.shop_active, this.shop_id});


  @override
  _addtablesState createState() => _addtablesState();
}

class _addtablesState extends State<addtables> {

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  var alltables = <Widget>[];

  var table_number = 1;
  Future<void> LoadTables() async {
    alltables.clear();

    var _alltables = <Widget>[];
    _alltables.clear();
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.shop_contact);
    DBRef.child("Shops/"+ widget.shop_contact.toString() + "/Tables").once().then((DataSnapshot dataSnapShot) {
      //print(dataSnapShot.value);
      table_number = 1;
      if (dataSnapShot.value != null) {
        var keys = dataSnapShot.value.keys;
        var values = dataSnapShot.value;

        for(var key in keys){
          table_number = table_number + 1;
          _alltables.add(
              new tables(
                Contact:widget.shop_contact,
                tablename: key,
                tableid: values[key]["Table_id"].toString(),
              )
          );
        }
      }
      setState(() {
        alltables = _alltables;
      });
    });

  }

  Future<void> Save_Table()  async {
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/" + widget.shop_contact.toString() + "/Tables/Table" + table_number.toString()).set({
      "Table_id":widget.shop_id + table_number.toString(),
    });
    print("Saved");
    setState(() {
      LoadTables();
    });
  }

  @override
  void initState() {
    LoadTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 50,
                left: 20,
              ),
              height: 150,
              child: Column(
                children: <Widget>[
                  Image.asset("Assets/logo.png",
                    height: 40,),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.shop_name.toString() + "'s " + "Tables",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ariel',
                      ),),
                    ],
                  ),

                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height - 150,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          height: 40,
                          color: Colors.grey,
                          onPressed: Save_Table,
                          child: Text("+ Add New Table",
                          style: TextStyle(
                            color: Colors.white,
                          ),),
                        ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 150 - 60,
                    child: RefreshIndicator(
                      key: refreshkey,
                      onRefresh: LoadTables,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: alltables.length,
                          itemBuilder: (a, index){

                            return alltables[index];

                          }),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
