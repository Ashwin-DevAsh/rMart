
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:flutter/cupertino.dart';

class CartListModel extends ChangeNotifier{
  List<CartProduct> cart = [];
  static List cartProductMap = [];

  init(cartMap){
    cart = [];
    cartProductMap = cartMap;
    cartProductMap.forEach((element) {
     cart.add(CartProduct.fromMap(element));
    });
    notifyListeners();
  }

  addItem(CartProduct cartProduct){
    if(cart.contains(cartProduct)){
      int position = cart.indexOf(cartProduct);
      cart[position].totalPrice+=cartProduct.totalPrice;
      cart[position].count+=cartProduct.count;
      cartProductMap[position] = cart[position].toJson();
    }else{
      this.cart.add(cartProduct);
      cartProductMap.add(cartProduct.toJson());
    }
    notifyListeners();
    UserContext.user.updateUserDatabase();
  }

  updateItem(product,count){
    int position = cart.indexOf(product);
    cart[position].count = count;
    cart[position].totalPrice = cart[position].product.price*count;
    cartProductMap[position] = cart[position].toJson();
    notifyListeners();
    UserContext.user.updateUserDatabase();
  }

  clear(){
    this.cart.clear();
    cartProductMap.clear();
    notifyListeners();
    UserContext.user.updateUserDatabase();
  }


  removeItem(int index){
    this.cart.removeAt(index);
    cartProductMap.removeAt(index);
    notifyListeners();
    UserContext.user.updateUserDatabase();
  }

}