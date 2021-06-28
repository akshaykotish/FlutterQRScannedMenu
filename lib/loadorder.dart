import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/background.dart';

import 'ColorCode.dart';
import 'billitems.dart';
import 'button.dart';

class loadorder extends StatefulWidget {

  String Name;
  String Phone;
  String Table;
  String Status;
  String Message;
  String Remark;
  String Shop_Contact;
  double Total_Amount;
  String OrderNumber;
  String Date;

  loadorder({this.Name, this.Phone, this.Table, this.Status, this.Message, this.Remark, this.Shop_Contact, this.Total_Amount, this.OrderNumber, this.Date});

  @override
  _loadorderState createState() => _loadorderState();
}

class _loadorderState extends State<loadorder> {
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  var orderitems = <Widget>[];


  Future<void> load_items() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));
    var _orderitems = <Widget>[];
    final DBRef = FirebaseDatabase.instance.reference();

    DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Items").once().then((DataSnapshot dataSnapShot) {
      //print(dataSnapShot.value);
      if (dataSnapShot.value != null) {
        var keys = dataSnapShot.value.keys;
        var values = dataSnapShot.value;

        for(var key in keys)
          {
              _orderitems.add(
                new billitems(
                  Name: values[key]["ItemName"],
                  Amount: double.parse(values[key]["Amount"].toString()),
                  Quantity: values[key]["Quantity"],
                  Rate: double.parse(values[key]["Rate"].toString()),
                )
              );
          }

        setState(() {
          orderitems = _orderitems;
        });

      }
    });


  }

  Future<void> Deliver()
  async {
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Status").set("D");
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Message").set("Delivered");
    Navigator.pop(context);
  }

  Future<void> TakeAway()
  async {
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Status").set("T");
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Message").set("Take Away");
    Navigator.pop(context);
  }

  Future<void> Cancel()
  async {
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Status").set("C");
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + widget.OrderNumber + "/Message").set("Cancelled");
    Navigator.pop(context);
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_items();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
              height: MediaQuery.of(context).size.height - 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("Assets/logo.png"),
                    padding: EdgeInsets.only(
                      top: 50,
                      left: 80,
                      right: 80,
                      bottom: 30,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[Text("Date : "), Text(widget.Date.toString(), style: TextStyle(fontWeight: FontWeight.bold),)],),
                        Row(children: <Widget>[Text("Name : "), Text(widget.Name, style: TextStyle(fontWeight: FontWeight.bold),)],),
                        Row(children: <Widget>[Text("Phone : "), Text("+91 " + widget.Phone, style: TextStyle(fontWeight: FontWeight.bold),)],),
                        Row(children: <Widget>[Text("Table : "), Text(widget.Table, style: TextStyle(fontWeight: FontWeight.bold),)],),
                        Row(children: <Widget>[Text("Status : "), Text(widget.Message, style: TextStyle(fontWeight: FontWeight.bold),)],),
                        Row(children: <Widget>[Text("Remark : "), Text(widget.Remark, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),)],),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Item Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        Text(" X ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        Text("Quantity",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        Text(" @ "),
                        Text("Rate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        Text(" = "),
                        Text("Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height - 480,
                    child: RefreshIndicator(
                      key: refreshkey,
                      onRefresh: load_items,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: orderitems.length,
                          itemBuilder: (a, index){

                            return orderitems[index];

                          }),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Text("Total Amount : "), Text("₹ " + widget.Total_Amount.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent))],),
                  )
                ],
              ),
            ),
            Container(
              color: GetColorFromHex('#B01A3F'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  button(
                    Button_Name: "Deliver",
                    Click: Deliver,
                  ),
                  button(
                    Button_Name: "Take Away",
                    Click: TakeAway,
                  ),
                  button(
                    Button_Name: "Cancel",
                    Click: Cancel,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
