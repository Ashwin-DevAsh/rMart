import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/Checkout.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/Widgets/ProductTileCart.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();

  var order;
  int totalAmount = 0;
  int totalItems = 0;
  var products = [];

  OrderDetails({this.order}){
    this.products = this.order["products"];
    this.products.forEach((element) { 
      totalAmount+= element["totalPrice"];
      totalItems +=element["count"];
    });
  }
}

class _OrderDetailsState extends State<OrderDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomSheet()  ,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelperWidgets.getHeader("Order ${widget.order["orederid"]}", (){Navigator.pop(context);}),

              Padding(
                padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                child: Center(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // children: [
                child:    QrImage(
                      data: (widget.order["orederid"]),
                      version: QrVersions.auto,
                      size: 250.0,
                    ),
                  // ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(){
    var status = widget.order["status"].toString();
    return  Material(
      // borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
      // elevation: 10,
      color: AppColors.backgroundColor,
      child: Container(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Divider(),
            SizedBox(height: 20,),
            orderedItems(),
            SizedBox(height: 25,),

            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Items",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  Text("${widget.totalItems}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tax",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  Text("0%",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  Text("${widget.totalAmount} Rc",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                ],
              ),
            ),

            Divider(),


            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 25,top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  Text("${widget.totalAmount} Rc",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left:0,right: 0),
              child: GestureDetector(
       
                child: Material(
                    elevation: 2.5,
                    shadowColor: AppColors.accentColor,
                    // borderRadius: BorderRadius.circular(10),
                    color: AppColors.accentColor,
                    child:Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(status.toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderedItems(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List
              .generate(
                 widget.products.length,
                  (index) {
                   print(widget.products);
                var productMap =  widget.products[index]["product"];
                var product = Product(
                    productMap["productID"],
                    productMap["productName"],
                    productMap["price"],
                    productMap["imageURL"],
                    productMap["productOwner"],
                    productMap["category"]);
                return productTile(CartProduct(product,
                    widget.products[index]["count"],
                    widget.products[index]["totalPrice"]));
              }
          )+[SizedBox(width: 30,)],
        ),
      ),
    );
  }

  Widget productTile(CartProduct cartProduct){
    return Padding(
      padding: const EdgeInsets.only(left:20.0,bottom: 5),
      child: Column(
        children: [
          Material(

            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            elevation: 0.5,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10) ,
                    border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
                ),
                height: 70,
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image(image: Image.network(cartProduct.product.imageURL).image,fit: BoxFit.scaleDown,width: 60,),
                      SizedBox(width: 10,),
                      Container(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                                child: Text(cartProduct.product.productName,
                                  overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                            Container(
                                width: 100,
                                child: Text("from "+ProductContext.getOwnerName(cartProduct.product.productOwner),
                                  overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: TextStyle(fontSize: 10,color: Colors.grey),)),
                            SizedBox(height: 5,),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.accentColor,
                              child: Padding(
                                padding: const EdgeInsets.only(top:2.5,bottom: 2.5,left: 10,right: 10),
                                child: Container(
                                    child: Text("x${cartProduct.count}",
                                      overflow: TextOverflow.ellipsis,maxLines: 1,
                                      style: TextStyle(fontSize: 10,color: AppColors.backgroundColor,fontWeight: FontWeight.bold),)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Text("${cartProduct.totalPrice} Rc",style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,)

                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          // Text("x${cartProduct.count}",style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }


  String getJwt(orderID){
      final key = 'DevAsh9551574355';
  final claimSet = new JwtClaim(
      otherClaims: <String,dynamic>{
        'orderID': orderID,
        },
    );

  String token = issueJwtHS256(claimSet, key);
  return (token);
  }
}