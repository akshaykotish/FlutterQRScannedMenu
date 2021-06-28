import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'background.dart';

class viewfeedbacks extends StatefulWidget {
  String Shop_Contact;

  viewfeedbacks({this.Shop_Contact});
  @override
  _viewfeedbacksState createState() => _viewfeedbacksState();
}

class _viewfeedbacksState extends State<viewfeedbacks> {

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  var all_orders = <Widget>[];

  Future<void> load_items() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    var _all_orders = <Widget>[];

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.Shop_Contact);
    DBRef.child("Shops/"+ widget.Shop_Contact +"/Feedbacks" ).once().then((DataSnapshot dataSnapShot) {
      //print(dataSnapShot.value);
      if (dataSnapShot.value != null) {
        var keys = dataSnapShot.value.keys;
        var values = dataSnapShot.value;

        for(var key in keys)
        {
          _all_orders.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      values[key]["Time"].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            "Message : "
                        ),
                        Text(
                            values[key]["message"].toString()
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
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
                          "Feedback Recieved",
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
