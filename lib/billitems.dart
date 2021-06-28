import 'package:flutter/material.dart';

class billitems extends StatefulWidget {

  String Name;
  int Quantity;
  double Rate;
  double Amount;

  billitems({this.Name, this.Quantity, this.Rate, this.Amount});

  @override
  _billitemsState createState() => _billitemsState();
}

class _billitemsState extends State<billitems> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.only(
            left: 10,
            right: 20,
              bottom: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(widget.Name.length < 20 ? widget.Name : widget.Name.substring(0, 20)),
              Text(" X "),
              Text(widget.Quantity.toString()),
              Text(" @ "),
              Text("₹ " + widget.Rate.toString()),
              Text(" = "),
              Text("₹ " + widget.Amount.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
