import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanapp/Feedback.dart';
import 'package:scanapp/OrderData.dart';
import 'package:scanapp/TextFld.dart';
import 'package:scanapp/background.dart';
import 'package:scanapp/billitems.dart';
import 'package:scanapp/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class placeorder extends StatefulWidget {

  String Shop_Contact;
  String Table_Number;
  String Table_ID;
  OrderData orderData;

  placeorder({this.Shop_Contact, this.Table_Number, this.Table_ID, this.orderData});

  @override
  _placeorderState createState() => _placeorderState();
}

class _placeorderState extends State<placeorder> {

  TextEditingController remarks_controll = new TextEditingController();
  String Name;
  String Phone;
  String Remark = "";
  double TotalAmount = 0.0;

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  var orderitems = <Widget>[];

  Future<void> load_items() async {
    refreshkey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 300));



    var _orderitems = <Widget>[];
    var id = widget.orderData.getItemDatas();
    print("Length " + OrderData.ItemDatas.length.toString());
    for(var i in id)
    {
      print(i.Name);
      TotalAmount = TotalAmount + i.Amount;
      _orderitems.add(
          new billitems(
            Name: i.Name,
            Quantity: i.Quantity,
            Rate: i.Rate,
            Amount: i.Amount,
          )
      );
    }


    setState(() {
      orderitems = _orderitems;
    });
  }

  Future<bool> Read_Pref() async {
    var pref = await SharedPreferences.getInstance();
    String _name = pref.getString("name");
    String _phone = pref.getString("phone");
    if(_name != null && _name != "" && _phone != null && _phone != "")
    {
      setState(() {
        Name = _name;
        Phone = _phone;
      });
      return true;
    }
    else{
      return false;
    }
  }

  String Generate_Order_Id(){
    var datetime = DateTime.now();
    String order_id = datetime.millisecond.toString() + datetime.second.toString() + datetime.minute.toString() + datetime.hour.toString();
    return order_id;
  }

  Future<void> Save_Order() async {
    String OrderName = Phone + "" + Generate_Order_Id();

    final DBRef = FirebaseDatabase.instance.reference();
    await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + OrderName).set({
      "Name":Name,
      "Phone":Phone,
      "Remark": Remark,
      "TotalAmount": TotalAmount,
      "TableName":widget.Table_Number,
      "TableID":widget.Table_ID,
      "Status":"P",
      "Message":"In Progress",
      "Date":DateTime.now().toString()
    });

    var id = widget.orderData.getItemDatas();
    for(var i in id) {
      await DBRef.child("Shops/"+ widget.Shop_Contact +"/Orders/" + OrderName + "/Items/" + i.Name).set({
        "ItemName":i.Name,
        "Quantity":i.Quantity,
        "Rate": i.Rate,
        "Amount": i.Amount,
      });
    }

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> feedback(
      Shop_Contact:  widget.Shop_Contact,
    )));

  }

  void OnRemarks(remark){
    Remark = remark;
    print(Remark);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Read_Pref();
    load_items();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: backgroundGradient,
                ),
                height: MediaQuery.of(context).size.height - 70,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: 60,
                          left: 50,
                          right: 50,
                          bottom: 20,
                        ),
                        child: Image.asset("Assets/logo.png"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Your Order",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text("Your table is " + widget.Table_Number.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Item Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                            Text(" X ",
                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                            Text("Quantity",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                            Text(" @ "),
                            Text("Rate",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                            Text(" = "),
                            Text("Amount",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height - 425,
                        child: RefreshIndicator(
                          key: refreshkey,
                          onRefresh: load_items,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: orderitems.length,
                              itemBuilder: (a, index){

                                return orderitems[index];

                              }),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        child: txtfld(
                          labeltext: "Remark",
                          hinttext: "Remark",
                          FieldController: remarks_controll,
                          function_controller: OnRemarks,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              button(
                Button_Name: "Confirm",
                Click: Save_Order,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
