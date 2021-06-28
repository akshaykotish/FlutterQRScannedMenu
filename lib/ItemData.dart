import 'package:flutter/services.dart';

class ItemData{
  String Name;
  int Quantity;
  double Rate;
  double Amount;

  ItemData(String n, int q, double r, double a){
    Name = n;
    Quantity = q;
    Rate = r;
    Amount = a;
    print(Name + " " + Quantity.toString() + " " + Rate.toString() + " " + Amount.toString());
  }

}