import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/OrderData.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/button.dart';
import 'package:scanapp/placeorder.dart';
import 'package:scanapp/switch.dart';

import 'ColorCode.dart';
import 'add_menu.dart';
import 'content.dart';


class showmenu extends StatefulWidget {

  String storename = "";
  String details = "";
  String contact = "";
  String tableId = "";
  String tablename= "";
  bool showedit = false;

  showmenu({this.storename, this.details, this.contact, this.showedit, this.tableId, this.tablename});

  @override
  _showmenuState createState() => _showmenuState();
}

class _showmenuState extends State<showmenu> {

  String Image_Url = "";

  File imagefile;

  Uint8List imagebytes;
  Widget LoadImage(){
    if(imagefile != null)
    {
      print("=====> 1");
      return Image.file(imagefile,
        width: 400,
        height: 400,
      );
    }
    else if(imagebytes != null)
    {
      print("=====> 2");
      return Image.memory(imagebytes, width: 400, height: 400,);
    }
    else{
      print("=====> 3");
      return Text("No Image Selected.");
    }

  }

  String ConvertImagetoBase64(){
    if(imagefile != null) {
      Uint8List bytes = imagefile.readAsBytesSync();
      return base64Encode(bytes);
    }
    return "";
  }

  OrderData orderData = new OrderData();

  String _tablename ="";

  bool veg = false;
  bool gluten = false;
  bool egg = false;

  TextEditingController search_controller = new TextEditingController();

  String search_text = "";

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  var show_edit = false;
  var chidlrens = <Widget>[];

  Future<void>  Read_Data() async{
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));

    chidlrens.clear();
    var _conts = <Widget>[];


    final CatgRef = await FirebaseDatabase.instance.reference();
    await CatgRef.child("Shops/"+ widget.contact +"/Menu").once().then((DataSnapshot catgdataSnapShot)
    async {
      if(catgdataSnapShot.value != null) {
        var catgkeys = catgdataSnapShot.value.keys;
        var catgvalues = catgdataSnapShot.value;

        for(var ck in catgkeys)
          {
            String categoryname = ck.toString();
            _conts.add(
              Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(
                left: 10,
                top: 15,
                bottom: 5,
                right: 10,
              ), child: new Text(categoryname, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),))
            );

            final DBRef = await FirebaseDatabase.instance.reference();
            print(widget.contact);
            await DBRef.child("Shops/"+ widget.contact +"/Menu/" + categoryname).once().then((DataSnapshot dataSnapShot)
            {
              //print(dataSnapShot.value);
              if(dataSnapShot.value != null) {
                var keys = dataSnapShot.value.keys;
                var values = dataSnapShot.value;

                if (keys != null) {
                  for (var key in keys) {
                    var Details = values[key]["Details"];
                    var Price = double.parse(values[key]["Price"].toString());
                    var Veg = values[key]["Veg"];
                    var _Gluten = values[key]["Gluten"];
                    var _Egg = values[key]["Egg"];
                    var Imagee = values[key]["Image"];
                    var Name = key;
                    print("Egg "+_Egg.toString());
                    show_edit = widget.showedit != null ? widget.showedit : false;

                    if (search_text != "") {
                      print(Name.toLowerCase().contains(search_text));
                      if (Name.toLowerCase().contains(search_text) == true) {
                        if ((gluten == true && gluten == _Gluten) ||
                            (veg == true && veg == Veg) ||
                            (egg == true && egg == _Egg)) {
                          _conts.add(new content(
                            details: Details,
                            price: Price,
                            veg: Veg,
                            image: Imagee,
                            Name: Name,
                            show_edit: show_edit,
                            gluten: _Gluten,
                            egg: _Egg,
                            Contact: widget.contact,
                            orderData: orderData,
                            category: categoryname,
                          ));
                        }
                        else {
                          if (gluten == false && veg == false && egg == false) {
                            _conts.add(new content(
                              details: Details,
                              price: Price,
                              veg: Veg,
                              image: Imagee,
                              Name: Name,
                              show_edit: show_edit,
                              gluten: _Gluten,
                              egg: _Egg,
                              Contact: widget.contact,
                              orderData: orderData,
                              category: categoryname,
                            ));
                          }
                        }
                      }
                    }
                    else {
                      if ((gluten == true && gluten == _Gluten) ||
                          (veg == true && veg == Veg) || (egg == true && egg == _Egg)) {
                        _conts.add(new content(
                          details: Details,
                          price: Price,
                          veg: Veg,
                          image: Imagee,
                          Name: Name,
                          show_edit: show_edit,
                          gluten: _Gluten,
                          egg: _Egg,
                          Contact: widget.contact,
                          orderData: orderData,
                          category: categoryname,
                        ));
                      }
                      else {
                        if (gluten == false && veg == false && egg == false) {
                          _conts.add(new content(
                            details: Details,
                            price: Price,
                            veg: Veg,
                            image: Imagee,
                            Name: Name,
                            show_edit: show_edit,
                            gluten: _Gluten,
                            egg: _Egg,
                            Contact: widget.contact,
                            orderData: orderData,
                            category: categoryname,
                          ));
                        }
                      }
                    }
                  }
                  //print(Name + ", " + Details + ", " + Price.toString() + ", " + Veg.toString() + ", " + Imagee);

                }

                setState(() {
                  chidlrens = _conts;
                });
              }
            });
          }

      }
    });


    setState(() {
      chidlrens = _conts;
    });
    return null;
  }


  Future<String> GetBanner()
  async {
    String banner = null;
    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.contact +"/Banner").once().then((DataSnapshot dataSnapShot){
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      if(keys != null && values["url"] != null)
      {
        print(values["url"]);
        banner = values["url"].toString();
        return banner;
      }
    });
    return banner;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Read_Data();
    if(widget.contact == null || widget.contact == "")
    {

    }
    if(widget.tablename != null && widget.tablename != "")
      {
        setState(() {
          _tablename = "Your table is " + widget.tablename;
        });
      }
    else{
      _tablename = "";
    }
    setState(() {
      show_edit = widget.showedit;
      print(chidlrens.length);
    });

    GetBanner().then((bnr){
      if(bnr != null)
      {
        Uint8List _imagebytes = base64Decode(bnr);
        setState(() {
          imagebytes = _imagebytes;
        });
      }
    });
  }

  void onsearchtextchange(e) async{
    search_text = e;
    await Read_Data();
  }

  getdata(){
    setState(() {
      chidlrens;
    });
    return chidlrens;
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height-70,
              decoration: BoxDecoration(
                //gradient: backgroundGradient,
              ),
              child: SingleChildScrollView(
                child: Container(
                  height:  MediaQuery.of(context).size.height-70,
                  child: RefreshIndicator(
                    key: refreshkey,
                    onRefresh: Read_Data,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          expandedHeight: 200,
                          backgroundColor: GetColorFromHex("#B11B40"),
                          floating: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: LoadImage(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: backgroundGradient,
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_tablename == "" ? "" : _tablename,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "ariel",
                                          fontSize: 10,
                                          color: Colors.yellow  ,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(widget.storename == null ? "Shop Name" : widget.storename,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "ariel",
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(widget.details == null ? "Shop Details" : widget.details,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "ariel",
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      child: TextField(
                                        controller: search_controller,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          hintText: "Search Items",
                                          prefixIcon: Icon(Icons.search, color: Colors.white,),
                                        ),
                                        onChanged: onsearchtextchange,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          switchbtn(
                                            state: veg,
                                            name: "Veg only",
                                            chng: (value){
                                              if(veg == true)
                                              {
                                                setState(() {
                                                  veg = false;
                                                  Read_Data();
                                                });
                                              }
                                              else{

                                                setState(() {
                                                  veg = true;
                                                  Read_Data();
                                                });
                                              }

                                            },
                                          ),
                                          switchbtn(
                                            state: gluten,
                                            name: "Gluten free",
                                            chng: (value){
                                              if(gluten == true)
                                              {
                                                setState(() {
                                                  gluten = false;
                                                  Read_Data();
                                                });
                                              }
                                              else{

                                                setState(() {
                                                  gluten = true;
                                                  Read_Data();
                                                });
                                              }
                                            },
                                          ),
                                          switchbtn(
                                            state: egg,
                                            name: "Include eggs",
                                            chng: (value){
                                              if(egg == true)
                                              {
                                                setState(() {
                                                  egg = false;
                                                  Read_Data();
                                                });
                                              }
                                              else{

                                                setState(() {
                                                  egg = true;
                                                  Read_Data();
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                            (context, poistion){
                              return chidlrens[poistion];
                            },
                              childCount: chidlrens.length,
                        ),

                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            button(
              Button_Name: show_edit == true ? "Add Item":"Place Order",
              Click: () async {
                if(show_edit == true) {
                  var value = await Navigator.push(
                      context, MaterialPageRoute(builder: (content) =>
                      addmenu(
                        title: "Create New Item",
                        contact: widget.contact,
                      )));
                  Read_Data();
                }
                else{
                  Navigator.pop(context);
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (content) =>
                      placeorder(
                        Shop_Contact: widget.contact,
                        Table_Number: widget.tablename,
                        Table_ID: widget.tableId,
                        orderData: orderData,
                      )));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
