import 'package:RMart/Models/User.dart';

class UserContext {
  static User user;

  static String get getId {
    return "rMart@" + user.number;
  }

  static int get getBalance {
    return int.parse(user.balance);
  }
}
