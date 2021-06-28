import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/Create_Menu.dart';
import 'package:scanapp/Create_Shop.dart';
import 'package:scanapp/Feedback.dart';
import 'package:scanapp/ShowMenu.dart';
import 'package:scanapp/add_menu.dart';
import 'package:scanapp/addtables.dart';
import 'package:scanapp/adminlogin.dart';
import 'package:scanapp/allorders.dart';
import 'package:scanapp/category.dart';
import 'package:scanapp/change_banner.dart';
import 'package:scanapp/createadmin.dart';
import 'package:scanapp/fwti.dart';
import 'package:scanapp/loadorder.dart';
import 'package:scanapp/placeorder.dart';
import 'package:scanapp/splashscreen.dart';
import 'package:scanapp/superadmin.dart';
import 'package:scanapp/tables.dart';
import 'package:scanapp/username.dart';
import 'package:scanapp/viewfeedbacks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background.dart';
import 'button.dart';
import 'logo.dart';
import 'home.dart';
import 'dish.dart';
import 'crud.dart';
import 'otp.dart';
import 'qrcode.dart';
import 'fwti.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<String> Read_Pref() async {
  var pref = await SharedPreferences.getInstance();
  String name = pref.getString("name");
  String phone = pref.getString("phone");
  if(name != null && name != "" && phone != null && phone != "")
  {
    return phone;
  }
    return "";
}

void callbackDispatcher() {

    Read_Pref().then((value) {
      final DBRef = FirebaseDatabase.instance.reference();
      DBRef.child("Users/" + value + "/Notification").once().then((
          DataSnapshot dataSnapShot) {
        print(dataSnapShot.value);
        if (dataSnapShot.value.toString().contains("Y")) {
        }
      });
    });

}



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "Dineeasy",
    theme: ThemeData(
      fontFamily: 'ariel'
    ),
    debugShowCheckedModeBanner: false,
    home:HomePage()
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {


  bool sts = false;

  Future<void> Read_Pref() async {
    var pref = await SharedPreferences.getInstance();
    var shop_name = pref.getString("shop_name");
    var shop_id = pref.getString("shop_id");


    if(shop_name != null && shop_name != "" && shop_id != null && shop_id != "")
      {
        setState(() {
          sts = true;
        });
      }
    else{
      setState(() {
        sts = false;
      });
    }
  }

  @override
  void initState() {
    //Read_Pref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: sts == true ? qrcode() : create_shop(),
     body:splashscreen(),
    );
  }
}
