import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanapp/button.dart';
import 'package:scanapp/loadorder.dart';

class allordersdata extends StatefulWidget {

  String Shop_Contact;
  String Name;
  String Phone;
  String Remark;
  String Message;
  String OrderID;
  String TableName;
  double OrderAmount;
  String Status;
  String Date;

  allordersdata({this.Date, this.Name, this.Phone, this.Remark, this.Message, this.OrderAmount, this.OrderID, this.TableName, this.Shop_Contact, this.Status});

  @override
  _allordersdataState createState() => _allordersdataState();
}

class _allordersdataState extends State<allordersdata> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Icon(Icons.shopping_bag, size: 40,)
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Order from ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                        Text(widget.TableName.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.Date.toString().substring(0, 18), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,),),
                        SizedBox(width: 50,),
                        FlatButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => loadorder(
                            Shop_Contact: widget.Shop_Contact,
                            Name: widget.Name,
                            Phone: widget.Phone,
                            Remark: widget.Remark,
                            OrderNumber: widget.OrderID,
                            Total_Amount: widget.OrderAmount,
                            Message: widget.Message,
                            Table: widget.TableName,
                            Status: widget.Status,
                            Date: widget.Date,
                          )));
                        },
                          minWidth: 50,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.view_agenda_outlined,
                                color: Colors.green,
                              ),
                              Text("View", style: TextStyle(color: Colors.green),)
                            ],
                          ),
                        ),
                      ],
                    )
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
