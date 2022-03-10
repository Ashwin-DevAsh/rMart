class Product{
  String productID;
  String productName;
  String imageURL;
  String productOwner;
  String category;
  int price;
  int discount;
  bool isDelivered;

  Product(this.productID, this.productName,this.price,this.imageURL,
      this.productOwner, this.category,this.discount,{this.isDelivered}){
      if(this.isDelivered == null){
        this.isDelivered = false;
      }
  }

  Product.fromMap(object){
    this.productID=object["productID"];
    this.productName=object["productName"];
    this.imageURL=object["imageURL"];
    this.productOwner=object["productOwner"];
    this.category=object["category"];
    this.price=object["price"];
    this.discount = object["discount"];
  }

  Map toMap(){
    return {
      "productID":productID,
      "productName":productName,
      "imageURL":imageURL,
      "productOwner":productOwner,
      "category":category,
      "price":price,
      "discount":discount
    };

  }

  @override
  bool operator ==(Object other) {
    // ignore: test_types_in_equals
    var isEqual = this.productName == (other as Product).productName && this.productOwner == (other as Product).productOwner;
    return isEqual;
  }

  @override
  int get hashCode => super.hashCode;


}