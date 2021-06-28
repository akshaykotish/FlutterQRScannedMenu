import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanapp/Create_Menu.dart';
import 'package:scanapp/Create_Shop.dart';
import 'package:scanapp/ShowMenu.dart';
import 'package:scanapp/addtables.dart';
import 'package:scanapp/category.dart';
import 'package:scanapp/change_banner.dart';
import 'package:scanapp/edit_menu.dart';
import 'package:scanapp/viewfeedbacks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'allorders.dart';
import 'background.dart';
import 'button.dart';
import 'package:ext_storage/ext_storage.dart';

import 'home.dart';


class qrcode extends StatefulWidget {
  String shop_name = "NONAME";
  String shop_details;
  String shop_address;
  String shop_id = "9643108Tas";
  String shop_contact;
  String shop_email;
  String shop_active = "Y";

  qrcode({this.shop_name, this.shop_details, this.shop_address, this.shop_email, this.shop_contact, this.shop_active, this.shop_id});

  @override
  _qrcodeState createState() => _qrcodeState();
}

class _qrcodeState extends State<qrcode> {


  _requestPermission(Permission permission) async
  {
  if(await permission.isGranted){
    return true;
  }
  else{
    var result = await permission.request();
    if(result == PermissionStatus.granted){
      return true;
    }
    else{
      return false;
    }
  }
  }

  GlobalKey globalKey = new GlobalKey();
  String shop_id_temp = "";
  String shop_name_temp = "";
  String shop_details_temp = "";
  String shop_contact_temp = "";


  Future<void> generate_qr() async {
    if(shop_id_temp.isEmpty)
      {
        setState(() {
          print("Hello");
        });
      }
    else{
      print("World");
      try {
        if(Platform.isAndroid){
          if(await _requestPermission(Permission.storage))
            {


            RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
            var image = await boundary.toImage();
            ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
            Uint8List pngBytes = byteData.buffer.asUint8List();

            final tempDir = await getApplicationDocumentsDirectory();
            var file = await new File('${tempDir.path}/qrcode.png').create();
            await file.writeAsBytes(pngBytes);
            print("Qr code saved! at " + file.toString());

            var path = await ExtStorage.getExternalStorageDirectory();
            file = await new File('${path}/qrcode.png').create();
            await file.writeAsBytes(pngBytes);
            print("Qr code saved! at " + file.toString());

            ImageGallerySaver.saveImage(pngBytes);

            }
          else{
            print("Permission denied");
          }
        }
        else{

        }
        //var result = await ImageGallerySaver.saveFile(pngBytes.toString());
        //print(result);
        /*
        final channel = const MethodChannel('channel:me.alfian.share/share');
        channel.invokeMethod('shareFile', 'image.png');
         */



      } catch(e) {
        print(e.toString());
      }
    }
  }

  void add_tablle(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => addtables(
      shop_name: shop_name_temp,
      shop_contact: shop_contact_temp,
      shop_details: shop_details_temp,
      shop_id: shop_id_temp,
    )));
  }

  void Load_Orders(){
    print(shop_contact_temp);
    Navigator.push(context, MaterialPageRoute(builder: (context) => allorders(
      Shop_Contact: shop_contact_temp,
      OrderType: "P",
    )));
  }

  void Load_All_Orders(){
    print(shop_contact_temp);
    Navigator.push(context, MaterialPageRoute(builder: (context) => allorders(
      Shop_Contact: shop_contact_temp,
      OrderType: "",
    )));
  }

  _qrcodeState(){

  }

  Future<bool> Read_Pref() async{
    var pref = await SharedPreferences.getInstance();
    setState(() {
      shop_id_temp = pref.getString("shop_id");
      shop_name_temp = pref.getString("shop_name");
      shop_details_temp = pref.getString("shop_details");
      shop_contact_temp = pref.getString("shop_contact");
    });

    if(shop_contact_temp != null && shop_contact_temp != "")
      {
        return true;
      }
    return false;
  }

  @override
  void initState() {
    super.initState();

    if(widget.shop_contact != null && widget.shop_contact != "" && widget.shop_name != null && widget.shop_name != "")
      {

        setState(() {
          shop_id_temp = widget.shop_id != null ? widget.shop_id : "";
          shop_name_temp = widget.shop_name != null ? widget.shop_name : "";
          shop_details_temp = widget.shop_details != null ? widget.shop_details : "";
          shop_contact_temp = widget.shop_contact != null ? widget.shop_contact : "";
        });

      }
    else {
      Read_Pref().then((value) {
        if (value != true) {
          new Future.delayed(
              Duration(
                milliseconds: 1,
              ),
                  () {
                    Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => create_shop()));
              }
          );
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Material(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height-70,
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
              child: Column(
                  children: <Widget>[
              Padding(
              padding: const EdgeInsets.only(
                  top: 70,
                  left: 70,
                  right: 70,
                  bottom: 50
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("Assets/logo.png", width: 100,),
                    SizedBox(width: 5,),
                    Text("Shop", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("hello ",
                        style: TextStyle(
                          fontFamily: "ariel",
                          fontSize: 25,
                          color: Colors.white,
                        ),),
                        Text(shop_name_temp,
                          style: TextStyle(
                            fontFamily: "ariel",
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                      ],
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height / 4) * 2.4,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("All features", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white),),
                                SizedBox(height: 20,),
                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.table_chart),
                                        SizedBox(width: 5,),
                                        Text("Add Tables"),
                                      ],
                                    ),
                                    onPressed: add_tablle,
                                  ),
                                  minWidth: 200,
                                ),
                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.shopping_bag_outlined),
                                        SizedBox(width: 5,),
                                        Text("Load New Orders"),
                                      ],
                                    ),
                                    onPressed: Load_Orders,
                                  ),
                                  minWidth: 200,
                                ),
                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.shopping_bag_outlined),
                                        SizedBox(width: 5,),
                                        Text("Load All Orders"),
                                      ],
                                    ),
                                    onPressed: Load_All_Orders,
                                  ),
                                  minWidth: 200,
                                ),
                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.feedback),
                                        SizedBox(width: 5,),
                                        Text("All Feedbacks"),
                                      ],
                                    ),
                                    onPressed: (){

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => viewfeedbacks(
                                        Shop_Contact: shop_contact_temp,
                                      )));
                                    },
                                  ),
                                  minWidth: 200,
                                ),
                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt),
                                        SizedBox(width: 5,),
                                        Text("Scan Code"),
                                      ],
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
                                    },
                                  ),
                                  minWidth: 200,
                                ),
                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.image),
                                        SizedBox(width: 5,),
                                        Text("Change Banner"),
                                      ],
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => changebanner(
                                        Shop_Name: shop_name_temp,
                                        Shop_Contact: shop_contact_temp,
                                        Shop_Address: widget.shop_address.toString(),
                                        Shop_Email: widget.shop_email.toString(),
                                      )));
                                    },
                                  ),
                                  minWidth: 200,
                                ),

                                ButtonTheme(
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.category_outlined),
                                        SizedBox(width: 5,),
                                        Text("Categories"),
                                      ],
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => category(
                                        contact: shop_contact_temp,
                                      )));
                                    },
                                  ),
                                  minWidth: 200,
                                ),
                              ],
                            ),
                          padding: EdgeInsets.all(30),
                          ),

                        ],
                      ),
                    ),

            ],
    ),
            ),
            button(
              Button_Name: "Menu",
              Click: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>showmenu(
                  storename: shop_name_temp,
                  details: shop_details_temp,
                  contact: shop_contact_temp,
                  showedit: true,
                )));
              },
            )
          ],
        ),
      ),
      );
  }
}
