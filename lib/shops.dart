import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:scanapp/ColorCode.dart';
import 'package:scanapp/button.dart';
import 'package:scanapp/qrcode.dart';
import 'package:scanapp/switch.dart';


class shops extends StatefulWidget {
  String name = "Kota Cafe";
  String contact = "8168131365";
  String details = "Coffee, Tea, Sandwich, Drinks and Snacks etc.";
  String email = "mail@kotacafe.com";
  String address = "Karnal Road, Kaithal";
  bool active = true;

  shops({this.name, this.contact, this.details, this.email, this.address, this.active});

  @override
  _shopsState createState() => _shopsState();
}

class _shopsState extends State<shops> {

  String name = "Kota Cafe";
  String contact = "8168131365";
  String details = "Coffee, Tea, Sandwich, Drinks and Snacks etc.";
  String email = "mail@kotacafe.com";
  String address = "Karnal Road, Kaithal";
  bool active = true;

  void onChange(bool){

    final DBRef = FirebaseDatabase.instance.reference();
    if(active == true){
      active = false;
    }
    else{
      active = true;
    }
    DBRef.child("Shops/" + contact + "/shop_active").set(active == true ? "Y" : "N");
    setState(() {

    });

  }

  void onDelete(){
    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Shops/"+ contact).remove();

    Toast.show("Shop deleted.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    String _name = widget.name;
    String _contact = widget.contact;
    String _details = widget.details;
    String _email = widget.email;
    String _address = widget.address;
    bool _active = widget.active;
    setState(() {
      name = _name;
      contact = _contact;
      details = _details;
      email = _email;
      address = _address;
      active = _active;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => qrcode(
          shop_name: widget.name,
          shop_contact: widget.contact,
          shop_address: widget.address,
          shop_active: widget.active == true ? "true":"false",
          shop_details: widget.details,
          shop_email: widget.email,
        )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 225,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shadowColor: GetColorFromHex("#F5F5F5"),
          color: GetColorFromHex("#B11B40"),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 70,
                        child: Icon(Icons.account_box,
                            size: 50,
                            color: Colors.white),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(name,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "ariel",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,

                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:5,),
                            child: Row(
                              children: <Widget>[
                                Text(("Details : "),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text((details),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:5,),
                            child: Row(
                              children: <Widget>[
                                Text(("Contact : "),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text((contact),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:5,),
                            child: Row(
                              children: <Widget>[
                                Text(("Email : "),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text((email),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:5,),
                            child: Row(
                              children: <Widget>[
                                Text(("Address : "),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text((address),
                                  style: TextStyle(
                                    fontFamily: "ariel",
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    switchbtn(
                      state: active,
                      name: "Active",
                      chng: onChange,

                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.delete, color: Colors.white, size: 30,), onPressed: onDelete),
                          Text("Delete", style: TextStyle(
                              fontFamily: "ariel",fontSize: 13, color: Colors.white),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
