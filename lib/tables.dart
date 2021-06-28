import 'package:firebase_database/firebase_database.dart';
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
import 'package:scanapp/edit_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background.dart';
import 'button.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:toast/toast.dart';
import 'home.dart';



class tables extends StatefulWidget {

  String Contact;
  String tablename;
  String tableid;

  tables({this.tablename, this.tableid, this.Contact});

  @override
  _tablesState createState() => _tablesState();
}

class _tablesState extends State<tables> {
  GlobalKey globalKey = new GlobalKey();


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

  Future<void> generate_qr() async {
    if(widget.tableid.isEmpty)
    {

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
            var file = await new File("${tempDir.path}/" + widget.tablename + ".png").create();
            await file.writeAsBytes(pngBytes);
            print("Qr code saved! at " + file.toString());

            var path = await ExtStorage.getExternalStorageDirectory();
            file = await new File('${path}/qrcode.png').create();
            await file.writeAsBytes(pngBytes);
            print("Qr code saved! at " + file.toString());

            ImageGallerySaver.saveImage(pngBytes);

            Toast.show("${tempDir.path}/" + widget.tablename + ".png", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          }
          else{
            print("Permission denied");
          }
        }
        else{

          Toast.show("No tables found.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
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


  void Delete(){
    final DBRef = FirebaseDatabase.instance.reference();
    DBRef.child("Shops/"+ widget.Contact +"/Tables/" + widget.tablename).remove();


    Toast.show("table deleted.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                      data: widget.tableid != null ? widget.tableid : "Apple",
                      backgroundColor: Colors.white,

                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.tablename != null ? widget.tablename : "Table 1",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),),
                    FlatButton(
                      color: Colors.white,
                      child: Icon(Icons.download_sharp),
                      onPressed: generate_qr,
                    ),
                    FlatButton(
                      color: Colors.white,
                      child: Icon(Icons.delete),
                      onPressed: Delete,
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
