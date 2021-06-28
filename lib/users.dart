import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/ColorCode.dart';
import 'package:scanapp/button.dart';
import 'package:scanapp/switch.dart';


class users extends StatefulWidget {

  String name = "Akshay Kotish";
  String contact = "8168131365";
  bool active = true;

  users({this.name, this.active, this.contact});

  @override
  _usersState createState() => _usersState();
}

class _usersState extends State<users> {

  String name = "Akshay Kotish";
  String contact = "8168131365";
  bool active = true;

  void onChnage(e){
    final DBRef = FirebaseDatabase.instance.reference();
    if(active == true){
      active = false;
    }
    else{
      active = true;
    }
    DBRef.child("Users/" + contact + "/Active").set(active == true ? "Y" : "N");
    setState(() {

    });
  }

  void onDelete(){
    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Users/"+ contact).remove();
  }

  @override
  void initState() {
    String _name = widget.name;
    String _contact = widget.contact;
    bool _active = widget.active;

    setState(() {
      name = _name;
      contact = _contact;
      active = _active;
    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 155,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shadowColor: GetColorFromHex("#F5F5F5"),
        color: GetColorFromHex("#B11B40"),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
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
                          fontFamily: "ariel",
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:5,),
                        child: Row(
                          children: <Widget>[
                            Text(("Contact : "),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "ariel",
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
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  switchbtn(
                    state: active,
                    name: "Active",
                    chng: onChnage,

                  ),
                  GestureDetector(
                    onTap: onDelete,
                      child: Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.delete, color: Colors.white, size: 30,), onPressed:  onDelete),
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
    );
  }
}
