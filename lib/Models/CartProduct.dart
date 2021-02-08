import 'package:RMart/Models/Product.dart';

class CartProduct{
  Product product;
  int count=1;
  int totalPrice;

  CartProduct(this.product, this.count, this.totalPrice);

  Map toJson(){
      return {
        "product":product.toMap(),
        "count":this.count,
        "totalPrice":this.totalPrice
      };
  }

  CartProduct.fromMap(object){
    product = Product.fromMap(object["product"]);
    count = object["count"];
    totalPrice = object["totalPrice"];
  }

  @override
  bool operator ==(Object other) {
    // ignore: test_types_in_equals
    return product == (other as CartProduct).product;
  }

  @override
  int get hashCode => super.hashCode;



}