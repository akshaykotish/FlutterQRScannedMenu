import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/shops.dart';
import 'package:scanapp/users.dart';

import 'ColorCode.dart';

class look extends StatefulWidget {

  bool shops;

  look({this.shops});

  @override
  _lookState createState() => _lookState();
}

class _lookState extends State<look> {

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  TextEditingController search_controller = new TextEditingController();

  String searchtext = "";

  var childs = <Widget>[];

  Future<void> Read_User() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    childs.clear();
    var _childs = <Widget>[];

    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Users").once().then((DataSnapshot dataSnapShot)
    {

      //print(dataSnapShot.value);
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for(var key in keys) {
        var Name = values[key]["Name"];
        var Phone = values[key]["Phone"];
        var Active = values[key]["Active"] == "Y" ? true : false;


        if(searchtext != "") {
          //print(name.toLowerCase().contains(searchtext));
          if(Name.toLowerCase().contains(searchtext) == true) {
            _childs.add(new users(
              name: Name,
              contact: Phone,
              active: Active,
            ));
          }
        }
        else{
          _childs.add(new users(
            name: Name,
            contact: Phone,
            active: Active,
          ));
        }
        //print(Name + ", " + Details + ", " + Price.toString() + ", " + Veg.toString() + ", " + Imagee);

      }

      setState(() {
        childs = childs;
      });

    });

    setState(() {
      childs = _childs;
    });

    return null;
  }


  Future<void> Read_Shops() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    childs.clear();
    var _childs = <Widget>[];

    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Shops").once().then((DataSnapshot dataSnapShot)
    {

      //print(dataSnapShot.value);
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      if(values != null) {
        for (var key in keys) {
          var name = values[key]["Name"];
          var address = values[key]["address"];
          var details = values[key]["details"];
          var shop_contact = values[key]["shop_contact"];
          var shop_email = values[key]["shop_email"];
          bool active = values[key]["shop_active"] == "Y" ? true : false;

          if(name == null || name == "")
            {
              Toast.show("Some enteries are invalid.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            }
          else {
            if (searchtext != "") {
              //print(name.toLowerCase().contains(searchtext));
              if (name.toLowerCase().contains(searchtext) == true) {
                _childs.add(new shops(
                  name: name,
                  contact: shop_contact,
                  email: shop_email,
                  details: details,
                  address: address,
                  active: active,
                ));
              }
            }
            else {
              _childs.add(new shops(
                name: name,
                contact: shop_contact,
                email: shop_email,
                details: details,
                address: address,
                active: active,
              ));
            }
            //print(Name + ", " + Details + ", " + Price.toString() + ", " + Veg.toString() + ", " + Imagee);
          }
        }
      }

      setState(() {
        childs = childs;
      });

    });

    setState(() {
      childs = _childs;
    });

    return null;
  }

  void onsearchtextchange(e){
    searchtext = e;
    if(widget.shops != null && widget.shops == true) {
      Read_Shops();
    }
    else{
      Read_User();
    }
  }

  @override
  void initState() {
    if(widget.shops != null && widget.shops == true) {
      Read_Shops();
    }
    else{
      Read_User();
    }
    super.initState();
  }

  Future<void> onRefresh() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    if(widget.shops != null && widget.shops == true) {
      Read_Shops();
    }
    else{
      Read_User();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(
              top: 40,
              bottom: 20,
            ),
            child: Image.asset("Assets/minilogo.png",
            width: 100,),),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 5,
                bottom: 5,
              ),
              child: Material(
                child: TextField(
                  controller: search_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: GetColorFromHex("#B11B40")),
                    ),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: GetColorFromHex("#B11B40"),),
                  ),
                  onChanged: onsearchtextchange,
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height/4) * 3.179,
              decoration: BoxDecoration(
                //gradient: backgroundGradient,
                color: Colors.white,
              ),
              child: RefreshIndicator(
                key: refreshkey,
                onRefresh: onRefresh,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: childs.length,
                    itemBuilder: (a, index){
                      return childs[index];
                    }),
              ),
              /*ListView(
                    scrollDirection: Axis.vertical,
                    children: chidlrens.length != 0 ? chidlrens : <Widget>[Center(
                      child: Text("Loading data..."),
                    ),],
                  )*/
            ),
          ],
        ),
      ),
    );
  }
}
