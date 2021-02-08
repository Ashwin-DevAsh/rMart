import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:sembast/sembast.dart';

class User {
  String name;
  String number;
  String rpayId;
  String rmartId;
  String email;
  List cart;
  List favourite;


  User({this.name,this.number,this.email,this.cart,this.favourite}){
    this.rpayId = "rpay@"+this.number;
    this.rmartId = "rmart@"+this.number;
  }

  User.fromMap(Map map){
     this.name = map["name"];
     this.number = map["number"];
     this.rpayId = "rpay@"+map["number"];
     this.rmartId = "rmart@"+map["number"];
     this.email = map["email"];
     this.cart = List.from(map["cart"]);
     this.favourite = List.from(map["favourite"]);
  }

  Map toMap(){
    return {
        "name":name,
        "number":number,
        "email":email,
        "cart":cart,
        "favourite":favourite
    };
  }

  updateUserDatabase() async {
    this.cart = CartListModel.cartProductMap;
    this.favourite = FavouriteListModel.favouriteMap;
    StoreRef.main().record("User").update(DataBaseHelper.db, this.toMap());
  }


}