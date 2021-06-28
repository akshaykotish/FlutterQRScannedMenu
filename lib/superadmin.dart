import 'package:flutter/material.dart';
import 'package:scanapp/createadmin.dart';
import 'package:scanapp/qrcode.dart';

import 'background.dart';
import 'home.dart';
import 'look.dart';

class superadmin extends StatefulWidget {
  @override
  _superadminState createState() => _superadminState();
}

class _superadminState extends State<superadmin> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 80,
                    left: 70,
                    right: 70,
                    bottom: 50
                ),
                child: Container(
                  child :Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset("Assets/logo.png", width: 200,),
                      SizedBox(width: 5,),
                      Text("Admin", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10),
              child: Text("Administration",
              style: TextStyle(
                fontFamily: "ariel",
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 150,
                        height: 150,
                        
                        child: Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.supervised_user_circle, color: Colors.white,),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (content) => look(
                                shops: false,
                              )));

                            },
                            iconSize: 60,),
                            Text("Users",
                            style: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 150,
                        height: 150,
                        
                        child: Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.shop, color: Colors.white,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (content) => look(
                                  shops: true,
                                )));

                              },
                              iconSize: 60,),
                            Text("Shops",
                              style: TextStyle(
                                fontFamily: "ariel",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 150,
                        height: 150,
                        
                        child: Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.admin_panel_settings, color: Colors.white,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => createadmin()));
                              },
                              iconSize: 60,),
                            Text("Change Pin",
                              style: TextStyle(
                                fontFamily: "ariel",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 150,
                        height: 150,
                        
                        child: Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.shopping_bag, color: Colors.white,),
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => qrcode()));
                              },
                              iconSize: 60,),
                            Text("Run as Shop",
                              style: TextStyle(
                                fontFamily: "ariel",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: 150,
                      height: 150,
                      
                      child: Column(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.supervised_user_circle_rounded, color: Colors.white,),
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
                            },
                            iconSize: 60,),
                          Text("Run as User",
                            style: TextStyle(
                              fontFamily: "ariel",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),)
                        ],
                      ),
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
