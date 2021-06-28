/*
import 'package:flutter/material.dart';
import 'content.dart';
import 'background.dart';
import 'button.dart';
import 'ColorCode.dart';
import 'switch.dart';

class dishes extends StatefulWidget {

  String storename = "Food Paradise";
  String details = "Burger, Pizza, Italian and Beverages";
  String contact = "";

  dishes({this.storename, this.details, this.contact});

  @override
  _dishesState createState() => _dishesState();
}

class _dishesState extends State<dishes> {

  var chidlrens = <Widget>[];
  Future<void>  Read_Data() async{
    refreshkey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));

    chidlrens.clear();
    var _conts = <Widget>[];

    final DBRef = FirebaseDatabase.instance.reference();
    print(widget.contact);
    DBRef.child("Shops/"+ widget.contact +"/Menu").once().then((DataSnapshot dataSnapShot)
    {
      //print(dataSnapShot.value);
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for(var key in keys) {
        var Details = values[key]["Details"];
        var Price = double.parse(values[key]["Price"].toString());
        var Veg = values[key]["Veg"];
        var _Gluten = values[key]["Gluten"];
        var _Egg = values[key]["Egg"];
        var Imagee = values[key]["Image"];
        var Name = key;

        if((gluten == true && gluten == _Gluten) || (veg == true && veg == Veg)  || (egg == true && egg == _Egg))
        {
          _conts.add(new content(
            details: Details,
            price: Price,
            veg: Veg,
            image: Imagee,
            Name: Name,
            show_edit: true,
            gluten: _Gluten,
            egg: _Egg,
            Contact: widget.contact,
          ));
        }
        else{
          if(gluten == false && veg == false && egg == false)
          {
            _conts.add(new content(
              details: Details,
              price: Price,
              veg: Veg,
              image: Imagee,
              Name: Name,
              show_edit: true,
              gluten: _Gluten,
              egg: _Egg,
              Contact: widget.contact,
            ));
          }
        }
        //print(Name + ", " + Details + ", " + Price.toString() + ", " + Veg.toString() + ", " + Imagee);

      }

      setState(() {
        chidlrens = _conts;
      });

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
    setState(() {
      print(chidlrens.length);
    });
  }


  @override
  Widget build(BuildContext context) {

    return new Material(
      child: Container(decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),
                                  Text(widget.details == null ? "" : widget.details,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
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
                                            state: false,
                                            name: "Veg only",
                                          ),
                                          switchbtn(
                                            state: false,
                                            name: "Gluten free",
                                          ),
                                          switchbtn(
                                            state: false,
                                            name: "Include eggs",
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
              height: MediaQuery.of(context).size.height/4 *2.65,
              decoration: BoxDecoration(
                //gradient: backgroundGradient,
                color: Colors.white,
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: chidlrens,
              )
            ),
            button(
              Button_Name: "Feedback",
            ),
          ],
        ),
      ),
    );

  }
}
*/