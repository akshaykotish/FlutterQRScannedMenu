import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:scanapp/Create_Menu.dart';
import 'package:scanapp/ShowMenu.dart';
import 'package:scanapp/dish.dart';
import 'package:scanapp/username.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ColorCode.dart';
import 'logo.dart';
import 'button.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:toast/toast.dart';




class home extends StatefulWidget {

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  String shop_name = "";
  String shop_contact = "";
  String shop_details = "";
  String table_name = "";

  void Load_Store(result) {

    String _shop_name = "";
    String _shop_contact = "";
    String _shop_details = "";
    String _table_name = "";

    final DBRef = FirebaseDatabase.instance.reference();

    DBRef.child("Shops/").once().then((DataSnapshot dataSnapShot) {
      //print(dataSnapShot.value);
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        var sid = values[key]["id"];
        var active = values[key]["shop_active"];
        print(sid + " == " + result);
        if(result.toString().contains(sid) && active ==  "Y")
          {
            _shop_name = values[key]["Name"];
            _shop_contact = values[key]["shop_contact"];
            _shop_details = values[key]["details"];
            print("Shop Name => " + _shop_name);

            DBRef.child("Shops/" + _shop_contact + "/Tables").once().then((DataSnapshot tabledataSnapShot){
                var tablekeys = tabledataSnapShot.value.keys;
                var tablevalues = tabledataSnapShot.value;
                for(var tkey in tablekeys)
                  {
                    var tId = tablevalues[tkey]["Table_id"].toString();
                    if(tId == result)
                      {
                        _table_name = tkey;
                        print(_table_name);
                        setState(() {
                          shop_name = _shop_name;
                          shop_contact = _shop_contact;
                          shop_details = _shop_details;
                          table_name = _table_name;
                        });

                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>showmenu(
                          contact: shop_contact,
                          storename: shop_name,
                          details: shop_details,
                          tableId: result,
                          tablename: _table_name,
                          showedit: false,
                        )));
                        break;
                      }
                    else{

                      Toast.show("Invalid QR code", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                    }

                  }
            });
            break;
          }
      }

    });
  }

  String result = "SCAN CODE";
  Future barcodeScanning() async {
    try {
      ScanResult scanResult = await BarcodeScanner.scan();
      String barcode = scanResult.rawContent;
      setState(
              () {
                this.result = "";
                this.result = barcode.toString();

              }
      );
      if(this.result.length > 0)
      {
        await Load_Store(result);

      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.result = 'No camera permission!';
        });
      } else {
        setState(() => this.result = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.result =
      'Nothing captured.');
    } catch (e) {
      setState(() => this.result = 'Unknown error: $e');
    }
  }

  Future<bool> Read_Pref() async {
    var pref = await SharedPreferences.getInstance();
    String name = pref.getString("name");
    String phone = pref.getString("phone");
    if(name != null && name != "" && phone != null && phone != "")
      {
        return true;
      }
    else{
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    bool contn = false;
    Read_Pref().then((value){
      contn = value;
      if(contn == false)
      {
        new Future.delayed(
            Duration(
              microseconds: 1
            ),
                (){
                  Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => username()));
            }
        );
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: logo(),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                            "Just 3 Steps",
                            style: TextStyle(
                              fontFamily: "ariel",
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left : 30, right: 30, bottom: 15, top: 30),
                          child: Text(
                            "1. Find QR code in the resturant, it could be right there on your table.",
                            style: TextStyle(
                              fontFamily: "ariel",
                              fontSize: 18,
                              color: Colors.white,
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left : 30, right: 30, bottom: 15, top: 15),
                          child: Text(
                            "2. Click on the SCAN CODE button and scan the code.",
                            style: TextStyle(
                              fontFamily: "ariel",
                              fontSize: 18,
                              color: Colors.white,
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left : 30, right: 30, bottom: 15, top: 15),
                          child: Text(
                            "3. Browse through numerous dishes and offers.",
                            style: TextStyle(
                              fontFamily: "ariel",
                              fontSize: 18,
                              color: Colors.white,
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 130,
                  ),



                ],
              ),

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        GetColorFromHex("#B11B40"),
                        GetColorFromHex("#5E1325"),
                      ]
                  )
              ),
            ),
          ),
          button(
            Button_Name: "Scan Code",
            Click: barcodeScanning,
          ),
        ],
      ),
    );
  }
}
