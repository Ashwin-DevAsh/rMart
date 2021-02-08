import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProductTileCart extends StatefulWidget {

  CartProduct cartProduct;

  ProductTileCart({this.cartProduct});

  @override
  _ProductTileCartState createState() => _ProductTileCartState();
}

class _ProductTileCartState extends State<ProductTileCart> {

  var counter = 0;
  @override
  void initState() {
    counter =widget.cartProduct.count;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:20,right: 20,bottom: 20),
      child: Material(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 0.5,
        child: Container(
          decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(20) ,
              border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
          ),
          height: 130,
          width: MediaQuery.of(context).size.width-40,

          child: Padding(
            padding: const EdgeInsets.only(left:10.0,right: 10),
            child: Row(
              children: [
                Image(image: Image.network(widget.cartProduct.product.imageURL).image,height: 100,width: 120,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width-200,
                    child: Consumer<CartListModel>(
                      builder:(context,cart,_)=> Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.cartProduct.product.productName,
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,fontFamily: AppFonts.textFonts),),
                          Text("from ${ProductContext.getOwnerName(widget.cartProduct.product.productOwner)}",
                            style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,fontFamily: AppFonts.textFonts,color: Colors.grey),),
                          Padding(
                            padding: const EdgeInsets.only(top:20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                counterButton(cart),
                                Text("Rc ${widget.cartProduct.totalPrice}",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18),)
                              ],
                            ),
                          )
                        ],),
                    ),
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }

  Widget counterButton(CartListModel cart){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 10,
          shadowColor: AppColors.accentColor,
          color: AppColors.accentColor,
          child: Stack(
            children: [
              Container(
                height: 30,width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(AntDesign.minus,color: AppColors.iconColor,size: 16,),
                    ),
                    Text(counter.toString(),style: TextStyle(color: AppColors.textColorLight,fontWeight: FontWeight.bold,fontSize: 16),),
                    Icon(Ionicons.ios_add,color: AppColors.iconColor,size: 20,)
                  ],
                ),
              ),

              Container(
                height: 30,width: 70,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap:(){
                        if(counter>1){
                           cart.updateItem(widget.cartProduct, --counter);
                        }
                      },
                      child: Container(
                          color: Colors.transparent,
                          height: 30,
                          width: 35
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        cart.updateItem(widget.cartProduct, ++counter);
                      },
                      child: Container(
                          color: Colors.transparent,
                          height: 30,
                          width: 35
                      ),
                    )
                  ],),
              )

            ],

          ),
        )
      ],
    );
  }

}
