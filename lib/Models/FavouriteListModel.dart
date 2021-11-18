import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/Models/Product.dart';
import 'package:flutter/cupertino.dart';

class FavouriteListModel extends ChangeNotifier {
  List<Product> favourite = [];
  static List favouriteMap = [];

  init(cartMap) {
    favourite = [];
    favouriteMap = cartMap;
    favouriteMap.forEach((element) {
      favourite.add(Product.fromMap(element));
    });

    notifyListeners();
  }

  toggleFavourite(Product product) {
    if (favourite.contains(product)) {
      var index = favourite.indexOf(product);
      favourite.remove(product);
      favouriteMap.removeAt(index);
    } else {
      favourite.add(product);
      favouriteMap.add(product.toMap());
    }

    notifyListeners();
    UserModel.user.updateUserDatabase();
  }
}
