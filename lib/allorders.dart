import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/allordersdata.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/button.dart';

import 'ColorCode.dart';

class allorders extends StatefulWidget {

  String Shop_Contact;
  String OrderType;
  allorders({this.OrderType, this.Shop_Contact});

  @override
  _allordersState createState() => _allordersState();
}

class _allordersState extends State<allorders> {

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  var all_orders = <Widget>[];



  Future<void> load_items() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    var _all_orders = <Widget>[];

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.Shop_Contact);
    DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders").once().then((DataSnapshot dataSnapShot) {
      //print(dataSnapShot.value);
      if (dataSnapShot.value != null) {
        var keys = dataSnapShot.value.keys;
        var values = dataSnapShot.value;

        for(var key in keys)
          {
            if(widget.OrderType != null && (values[key]["Status"] == widget.OrderType || widget.OrderType == ""))
            _all_orders.add(new allordersdata(
              Shop_Contact: widget.Shop_Contact,
              Name: values[key]["Name"],
              Phone: values[key]["Phone"],
              Remark: values[key]["Remark"],
              Message: values[key]["Message"],
              TableName: values[key]["TableName"],
              Date: values[key]["Date"],
              OrderAmount: double.parse(values[key]["TotalAmount"].toString()),
              OrderID: key,
              Status: values[key]["Status"],
            ));
          }
        setState(() {
          all_orders = _all_orders;
        });
      }
    });

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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: backgroundGradient,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:EdgeInsets.only(
                          top: 60,
                          left: 100,
                          right: 100,
                          bottom: 20,
                        ),
                        child: Image.asset("Assets/logo.png"),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Live Orders",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 205,
                        child: RefreshIndicator(
                          key: refreshkey,
                          onRefresh: load_items,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: all_orders.length,
                              itemBuilder: (a, index){

                                return all_orders[index];

                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
