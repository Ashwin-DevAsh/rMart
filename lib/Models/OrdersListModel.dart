
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:flutter/cupertino.dart';

class OrderListModel extends ChangeNotifier{

  refresh()async{
    notifyListeners();
  }
}