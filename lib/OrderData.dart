import 'package:flutter/cupertino.dart';
import 'package:scanapp/ItemData.dart';

class OrderData{
  static List<ItemData> ItemDatas = new List<ItemData>();

  List<ItemData> getItemDatas()
  {
    return ItemDatas;
  }

  static String remarks = "";
  void Add_New(String n, int q, double r, double a)
  {
    bool flag = false;
    for(var ids in ItemDatas)
      {
        if(ids.Name == n)
          {
            flag = true;
            ids.Quantity = q;
            ids.Rate = r;
            ids.Amount = a;
            break;
          }
      }
    if(flag == false){
      ItemData id = new ItemData(n, q, r, a);
      ItemDatas.add(id);
    }
  }
}