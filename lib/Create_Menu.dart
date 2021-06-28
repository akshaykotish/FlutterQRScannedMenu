import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/TextFld.dart';
import 'add_menu.dart';
import 'content.dart';
import 'background.dart';
import 'button.dart';
import 'ColorCode.dart';
import 'switch.dart';

class create_menu extends StatefulWidget {

  String storename = "Food Paradise";
  String details = "Burger, Pizza, Italian and Beverages";
  String contact = "";
  bool showedit = false;

  create_menu({this.storename, this.details, this.contact, this.showedit});

  @override
  _create_menuState createState() => _create_menuState();
}

class _create_menuState extends State<create_menu> {

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

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.contact);
    DBRef.child("Shops/"+ widget.contact +"/Menu").once().then((DataSnapshot dataSnapShot)
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

    setState(() {
      chidlrens = _conts;
    });
    return null;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Read_Data();
    if(widget.contact == null || widget.contact == "")
      {
        
      }
    setState(() {
      show_edit = widget.showedit;
      print(chidlrens.length);
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
    setState(() {
      print(chidlrens.length);
    });
    return new Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
        gradient: backgroundGradient,
      ),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/4 *1,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("Assets/img.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(GetColorFromHex("#B11B40").withOpacity(0.35), BlendMode.dstATop),
                            alignment: Alignment.topCenter
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5,),
                                Container(
                                  child: Image.asset("Assets/minilogo.png",
                                    width: 100,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(widget.storename == null ? "" : widget.storename,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "ariel",
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(widget.details == null ? "" : widget.details,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "ariel",
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
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
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 5,
                  bottom: 5,
                ),
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
              Container(
                  height: (MediaQuery.of(context).size.height/4) * 2.31,
                  decoration: BoxDecoration(
                    //gradient: backgroundGradient,
                    color: Colors.white,
                  ),
                  child: RefreshIndicator(
                    key: refreshkey,
                    onRefresh: Read_Data,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                        itemCount: chidlrens.length,
                        itemBuilder: (a, index){

                            return chidlrens[index];

                    }),
                  ),
                /*ListView(
                    scrollDirection: Axis.vertical,
                    children: chidlrens.length != 0 ? chidlrens : <Widget>[Center(
                      child: Text("Loading data..."),
                    ),],
                  )*/
              ),
              button(
                Button_Name: show_edit == true ? "Add New":"Feedback",
                Click: () async {
                  if(show_edit == true) {
                    Navigator.pop(context);
                    var value = await Navigator.push(
                        context, MaterialPageRoute(builder: (content) =>
                        addmenu(
                          title: "Create New Product",
                          contact: widget.contact,
                        )));
                    Read_Data();
                  }
                  else{

                  }
                  },
              ),
            ],
          ),
        ),
      ),
    );

  }
}
