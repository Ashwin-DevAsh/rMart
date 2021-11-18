import 'package:RMart/Models/User.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  static User user;

  static String get getId {
    return "rMart@" + user.number;
  }

  static int get getBalance {
    return int.parse(user.balance);
  }

  refresh() async {
    notifyListeners();
  }
}
