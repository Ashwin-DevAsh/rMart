import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:flutter/cupertino.dart';

class OrderListModel extends ChangeNotifier {
  refresh() async {
    notifyListeners();
  }
}
