import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:scanapp/qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background.dart';
import 'package:scanapp/TextFld.dart';
import 'button.dart';

class create_shop extends StatefulWidget {
  @override
  _create_shopState createState() => _create_shopState();
}

class _create_shopState extends State<create_shop> {

  String shop_name = "NONAME";
  String shop_details = "";
  String shop_address = "";
  String shop_id = "";
  String shop_contact = "";
  String shop_email = "";
  String shop_active = "Y";

  String error_name = null;
  String error_details = null;
  String error_address = null;
  String error_id = null;
  String error_contact = null;
  String error_email = null;

  void Generate_Shop_Id(){
    var datetime = DateTime.now();
    shop_id = datetime.millisecond.toString() + datetime.second.toString() + datetime.minute.toString() + datetime.hour.toString() + shop_name.substring(0, 3);
  }
  TextEditingController _bname = new TextEditingController();
  TextEditingController _bdescription = new TextEditingController();
  TextEditingController _baddress = new TextEditingController();
  TextEditingController _bemail = new TextEditingController();
  TextEditingController _bcontact = new TextEditingController();

void init_Play(){
  shop_name = _bname.text;
  shop_details = _bdescription.text;
  shop_address = _baddress.text;
  shop_email = _bemail.text;
  shop_contact = _bcontact.text;
}

void Save_Pref() async{
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString("shop_id", shop_id);
  await prefs.setString("shop_name", shop_name);
  await prefs.setString("shop_details", shop_details);
  await prefs.setString("shop_address", shop_address);
  await prefs.setString("shop_email", shop_email);
  await prefs.setString("shop_contact", shop_contact);
}

  void Create_Shop() async{
    init_Play();
    if(shop_name != "" && shop_email != "" && shop_contact != "" && shop_contact.length >=10 && shop_contact.length <= 13 && shop_email.contains("@") == true) {
      Generate_Shop_Id();
      final DBRef = FirebaseDatabase.instance.reference();
      await DBRef.child("Shops").child(shop_contact).set({
        "Name": shop_name,
        "details": shop_details,
        "address": shop_address,
        "id": shop_id,
        "shop_contact": shop_contact,
        "shop_email": shop_email,
        "shop_active": shop_active
      });
      await Save_Pref();
      Navigator.pop(context);
      await Navigator.push(context, MaterialPageRoute(builder: (context)=>qrcode(
        shop_name: shop_name,
        shop_email: shop_email,
        shop_address: shop_address,
        shop_id: shop_id,
        shop_active: shop_active,
        shop_contact: shop_contact,
        shop_details: shop_details,
      )));
    }
    else{

      Toast.show("Invalid details", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      setState(() {
        if(shop_name == "")
        {
          error_name = "Please enter business name.";
        }
        if(shop_address == "")
        {
          error_address = "Please enter a valid address.";
        }
        if(shop_details == "")
        {
          error_details = "Please enter business name.";
        }
        if(shop_contact == "" || (shop_contact.length >= 10 && shop_contact.length <= 13))
        {
          error_contact = "Please enter a valid contact.";
        }
        if(shop_email == "")
        {
          error_email = "Please enter a valid email address.";
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                      child : Image.asset("Assets/logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text("Register Your Business",
                      style: TextStyle(
                          fontFamily: "ariel",
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height/4) * 2.4,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            new txtfld(
                              hinttext: "Enter Business Name",
                              labeltext: "Your Business Name",
                              FieldController: _bname,
                              icon: Icon(
                                Icons.business_outlined,
                              ),
                              errortext: error_name,
                            ),
                          new txtfld(
                            hinttext: "Enter Brief Description",
                            labeltext: "Your Business Description",
                            FieldController: _bdescription,
                            icon: Icon(
                              Icons.description,
                            ),
                            errortext: error_details,
                          ),
                          new txtfld(
                            hinttext: "Enter Business Address",
                            labeltext: "Your Business Address",
                            FieldController: _baddress,
                            icon: Icon(
                              Icons.location_city,
                            ),
                            errortext: error_address,
                          ),
                          new txtfld(
                            hinttext: "Enter Business Email",
                            labeltext: "Your Business Email",
                            FieldController: _bemail,
                            textInputType: TextInputType.emailAddress,
                            icon: Icon(
                              Icons.email,
                            ),
                            errortext: error_email,
                          ),
                          new txtfld(
                            hinttext: "Enter Business Contact",
                            labeltext: "Your Business Contact",
                            FieldController: _bcontact,
                            textInputType: TextInputType.phone,
                            icon: Icon(
                              Icons.contact_page,
                            ),
                            len: 10,
                            prefixtext: "+91 ",
                            errortext: error_contact,
                          ),
                        ],
                      ),
                    ),)
                ],
              ),
            ),
            button(
              Button_Name: "Register",
              Click: Create_Shop,
            )
          ],
        ),
      ),
    );
  }
}
