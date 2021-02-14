import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/Cart.dart';
import 'package:RMart/Pages/CartHolder.dart';
import 'package:RMart/Pages/ProductDetails.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'AlertHelper.dart';
import 'ProductTile.dart';

class HelperWidgets{
  static Widget getHeader(context,heading,callBack,{showShoppingCart=false}){
    return Material(
      color: Colors.transparent,
          child: Padding(
        padding: const EdgeInsets.only(top: 20,bottom: 20,right: 15),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
                          child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      callBack();
                    },
                    child: Material(
                      elevation: 1,
                      color: AppColors.backgroundColor,
                      borderRadius:BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)) ,
                              border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
                          ),
                          height:40,
                          width: 60,
                          child: Icon(CupertinoIcons.back,size: 20,)),
                    ),
                  ),
                Text(heading,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,fontFamily: AppFonts.textFonts),),
                SizedBox(width:40),
                // Expanded(child: Center()),
    
              ],),
            ),
        !showShoppingCart?Center():    GestureDetector(
          onTap:(){
                                  HelperFunctions.navigate(context, CartHolder());

          },

                  child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           Expanded(child: Center()),
                      Consumer<CartListModel>(
                            builder:(context,cart,_)=>

                       Padding(
                         padding: const EdgeInsets.only(),
                         child: Stack(
                           children: [
                             Container(
                               width: 40,
                               child: Row(
                                 children: [
                                   Expanded(child: Center()),
                                   Material(
                                     color: Colors.red,
                                     borderRadius: BorderRadius.circular(7.5),
                                     child: Container(
                                       height: 15,width: 15,
                                       child: Center(child:Text("${cart.cart.length}",style: TextStyle(color: Colors.white,fontSize: 6),)),
                                       
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Icon(Entypo.shopping_cart, size: 25),
                            ),
                           ],
                         ),
                       ))
              ],),
        )
         
          ],
        ),
      ),
    );
  }

  static Widget customGridView(List<Product> items,context,{extraTile}){
    List<Widget> leftSide  = [];
    List<Widget> rightSide = [];

    for(var i =0;i<items.length;i++){
      if(i%2==0){
        leftSide.add(
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: productsTile(items[i]),
            )
        );
      }else{
        rightSide.add(
            Padding(
              padding: const EdgeInsets.only(right:20.0),
              child: productsTile(items[i]),
            )
        );
      }
    }

    if(extraTile!=null && items.length>0){
      List<Widget> space = [extraTile];
      rightSide = space + rightSide;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: leftSide,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: rightSide,
          ),
        )
      ],);
  }

  static Widget productsTile(Product object){
    return ProductTile(product: object,);
  }

  static Widget getCategory(context,categories,selectedCategory,callBack){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children:List.generate(categories.length, (index){
            return GestureDetector(
              onTap:()=>callBack(index),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: selectedCategory==index?AppColors.accentColor:Colors.transparent,width: 3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:20,right: 20),
                  child: Center(
                    child: Text(categories[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          } ),
        ),
      ),
    );
  }


  static productListTile(context,Product object,{showStoreName=false}){
    return Padding(
      padding: const EdgeInsets.only(left:20,right: 20,bottom: 20),
      child: Material(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 0.5,
        child: Stack(
          children: [
            Container(
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
                    CachedNetworkImage(
                       placeholder: (context, url) => Image.asset("lib/assets/Images/image_loading.png"),
                             fit: BoxFit.scaleDown,
                              imageUrl:object.imageURL,
                              height: 100,width: 120,
                          ),
                    // Image(image: Image.network(object.imageURL).image,height: 100,width: 120,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width-200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(object.productName,
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,),),
                            showStoreName?  Text("from ${ProductContext.getOwnerName(object.productOwner)}",
                              style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,fontFamily: AppFonts.textFonts,color: Colors.grey),):
                            Text( "⭐ ⭐ ⭐ ⭐ ⭐",
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontFamily: AppFonts.textFonts,color: Colors.grey),),

                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Rs ${object.price}",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15),)
                                ],
                              ),
                            )
                          ],),
                      ),
                    )
                  ],
                ),
              ),

            ),
            Consumer<CartListModel>(
              builder:(context,cart,_)=> GestureDetector(
                onTap: (){
                  HelperFunctions.navigate(context, ProductDetails(product: object,));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(20) ,
                  ),
                  height: 130,
                  width: MediaQuery.of(context).size.width-40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: ()async{
                             if(await HelperFunctions.isSameCategory(context,cart,object,1)){
                                    cart.addItem(CartProduct(object, 1, object.price));
                                    AlertHelper.showSuccessSnackBar(context, "Added Successfully !");
                             }
                        },
                        child: Material(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),topLeft: Radius.circular(20)),
                          color: AppColors.accentColor,
                          child: Container(height: 35,width: 70,
                            child: Center(
                              child: Icon(
                                Feather.shopping_cart,color: AppColors.backgroundColor,size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



}