import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/ProductDetails.dart';
import 'package:RMart/Widgets/AlertHelper.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatefulWidget {

  Product product;
  ProductTile({this.product});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.only(bottom:20.0),
      child: GestureDetector(
        onTap: (){
          HelperFunctions.navigate(context, ProductDetails(product: widget.product,));
        },
        child: Material(
          color: AppColors.backgroundColor,
          // shadowColor: AppColors.accentColor,
          elevation: 0.5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(20) ,
                border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
            ),
            height: 250,
            width: MediaQuery.of(context).size.width/2-30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:28.0,bottom: 28,left: 20,right: 20),
                  child: Container(
                      color: AppColors.backgroundColor,
                      height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:CachedNetworkImage(
                             fit: BoxFit.scaleDown,
                              imageUrl:widget.product.imageURL
                          ),
                          // child: Image(
                          //   image: Image.network(widget.product.imageURL).image,
                          //   fit: BoxFit.scaleDown,)
                      )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:10,right: 10,top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.productName,style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("From ${ProductContext.getOwnerName(widget.product.productOwner)}",style: TextStyle(fontSize: 10,fontFamily: AppFonts.textFonts,),),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Rc ${widget.product.price}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Consumer<CartListModel>(

                              builder:(context,cart,_)=> GestureDetector(
                                onTap: ()async{
                                if(HelperFunctions.isSameCategory(cart.cart, widget.product)){
                                    cart.addItem(CartProduct( widget.product, 1, widget.product.price));
                                    AlertHelper.showSuccessSnackBar(context, "Added Successfully !");
                                  }else{
                                    if(await HelperFunctions.showWarning(context, cart,widget.product)){
                                      Future.delayed(Duration(milliseconds: 500),(){
                                        cart.clear();
                                        cart.addItem(CartProduct( widget.product, 1, widget.product.price)); 
                                        AlertHelper.showSuccessSnackBar(context, "Added Successfully !");
                                      });
                                    }
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.accentColor.withAlpha(20),
                                  child: Container(height: 35,width: 35,
                                    child: Center(
                                      child: Icon(
                                        Feather.shopping_cart,color: AppColors.accentColor,size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
