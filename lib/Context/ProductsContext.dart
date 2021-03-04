import 'package:RMart/Api/ProductsApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Models/Product.dart';

class ProductContext{
  static List merchants = [];

  static Map merchantIDMap = {};

  static List categories = ['All'];

  static List<Product> allProducts = [];

  static Map<String,List> categoricalProducts = {};

  static List<Product> suggestions = [];

  static Map data = {};

  static String getOwnerName(String id){
    try{
      return merchantIDMap[id]["accountname"].toString().toLowerCase();
    }catch(e){
      return "None";
    }
  }

  static init(){
     for(var i in ProductsApi.categories){
       categories.add(i);
        categoricalProducts[i]=[];
     }
     data.forEach((store, categoryMap) {
        categoryMap.forEach((category, products) {
            if(!categories.contains(category)){
              categories.add(category);
            }
            for(var i in products){
              print(i);
              var product = Product( i["productid"], i["productname"],int.parse(i["price"]),ApiContext.productImageURL+i["imageurl"], store, category,i["discount"]);
              try{
                categoricalProducts[category].add(product);
              }catch(e){
                categoricalProducts[category]=[product];
              }

              allProducts.add(
                  product
              );
              if(suggestions.length<10){
                suggestions.add(
                  product
                );
              }
            }
        });
     });
  }
}