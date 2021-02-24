import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/Widgets/ProductTileCart.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'CartHolder.dart';
import 'Checkout.dart';


class Cart extends StatefulWidget {

  var callBack;
  var isFromCartHolder;

  Cart({this.callBack,this.isFromCartHolder=false});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  children: [
                    getHeader(context,"My Cart",widget.callBack),
                    SizedBox(height: 20,),
                    Consumer<CartListModel>(
                      builder: (context,cart,child){
                            return cart.cart.isEmpty?getEmptyWidget(): Column(
                              children: List.generate(cart.cart.length, (index) {
                                return Dismissible(
                                    onDismissed: (_){
                                      cart.removeItem(index);
                                    },
                                    key: UniqueKey(),
                                    child: productTile(cart.cart[index])
                                );
                              }),
                            );
                            },
                    )
                  ],
            ),),
          ),
         checkOutSheet()
        ],
    )

      );
  }

  Widget productTile(object){
    return ProductTileCart(cartProduct: object,) ;
  }


  Widget checkOutSheet(){
    return Consumer<CartListModel>(

      builder:(context,cart,_){
        var totalProducts=0;
        var totalPrice=0;

        for(CartProduct i in cart.cart){
          totalPrice+=i.totalPrice;
          totalProducts+=i.count;
        }

        return CartListModel.cartProductMap.isEmpty?Center(): Material(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
              color: AppColors.backgroundColor,
              elevation: 5,
              child: Container(
                height: widget.isFromCartHolder?90:160,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:  EdgeInsets.only(left:20.0,right: 20,bottom: widget.isFromCartHolder?0: 65),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total",style: TextStyle(fontSize: 12,fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,),),
                        Text("$totalProducts items",style: TextStyle(fontSize: 12,fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600),)
                      ],
                    ),
                     Padding(
                       padding: const EdgeInsets.only(left:20.0),
                       child: Text("$totalPrice Rs",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,fontFamily: AppFonts.textFonts),),
                     ),
                     Expanded(child: Container(),),
                       GestureDetector(
                            onTap: (){
                              HelperFunctions.navigate(context, CheckOut(
                                  CartListModel.cartProductMap,
                                  totalPrice,
                                  totalProducts,
                                  cart: cart,
                              ));
                            },
                            child: Material(
                               elevation: 5,
                               shadowColor: AppColors.accentColor,
                                borderRadius: BorderRadius.circular(10),
                               color: AppColors.accentColor,
                               child:Container(
                                 height: 35,
                                 width: 100,
                                 child: Center(
                                    child: Text("Checkout",style: TextStyle(color: Colors.white)),
                                 ),
                               )
                            ),
                          ),

                  ],),
                ),
              ),
      );
      },
    );
  }

  Widget getEmptyWidget(){
    return  Padding(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.075),
      child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right:20.0,top: 50,bottom: 40),
                child: Image(image: Image.asset("lib/assets/Images/cart2.png").image,width: MediaQuery.of(context).size.width*0.60,),
              ),
              SizedBox(height: 10,),
              Text("Your basket is empty",
                style: TextStyle(fontSize: 18,color: AppColors.accentColor,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Text("Make your basket happy by",style: TextStyle(fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,color: Colors.grey),),
              Text("adding foods to it",style: TextStyle(fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,color: Colors.grey))

            ],
          )
      ),
    );
  }


   Widget getHeader(context,heading,callBack,{showShoppingCart=false}){
    return Consumer<CartListModel>(
      builder: (context, cart,_) {
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
              cart.cart.length==0?Center():  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Expanded(child: Center()),
               

                    GestureDetector(
                      onTap: (){
                        clearCart(cart,context);
                      },
                                      child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Stack(
                          children: [
                       
                           Padding(
                             padding: const EdgeInsets.only(top:5),
                             child: Icon(MaterialIcons.delete, size: 27.5),
                           ),
                          ],
                        ),
                      ),
                    )
                  ],)
             
              ],
            ),
          ),
        );
      }
    );
  }

  clearCart(CartListModel cart,context){
       showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Delete cart"),
                  content: Text("All the items in the cart will be removed. Are you sure you want to delete the cart?"),
                  actions: <Widget>[
                         FlatButton(
                      onPressed: () {
                           Navigator.of(context).pop(true);
                                       
                      },

                      child: Text('NO',style: TextStyle(color: AppColors.accentColor)),
                    ),
                  
                    FlatButton(
                      onPressed: () {
                         Future.delayed(Duration(milliseconds: 500),(){
                                                      cart.clear();

                         });
                            Navigator.of(context).pop(true);
                                       
                      },

                      child: Text('YES',style: TextStyle(color: AppColors.accentColor)),
                    ),
                  ],
                );
              },
      );
  }

}