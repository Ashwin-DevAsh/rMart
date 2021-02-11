
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/Checkout.dart';
import 'package:RMart/Widgets/AlertHelper.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {

  Product product;

  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  var count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height:  MediaQuery.of(context).size.height-300,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HelperWidgets.getHeader(context, "", Navigator.of(context).pop,showShoppingCart: true), //simpleAppBar(),
                    Container(
                      height: (MediaQuery.of(context).size.height-300)*0.5,
                      child: CachedNetworkImage(
                      height: (MediaQuery.of(context).size.height-300)*0.5,width:(MediaQuery.of(context).size.width)*0.7,
                      imageUrl:widget.product.imageURL,
                      colorBlendMode: BlendMode.color,
                        fit: BoxFit.scaleDown,
                    ),
                      // child: Image(
                      //   colorBlendMode: BlendMode.color,
                      //   fit: BoxFit.scaleDown,
                      //   image: Image.network(widget.product.imageURL).image,
                      //   height: (MediaQuery.of(context).size.height-300)*0.5,width:(MediaQuery.of(context).size.width)*0.7,)
                    ),
                    SizedBox(height: 70,)
                  ],
                ),
              ),
            ),
            Column(children: [
              Expanded(child: Container()),
              bottomSheet()
            ],)

          ],
        ),
      ),
    );
  }

  Widget simpleAppBar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
                      child: Material(
              elevation: 1,
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius:BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                      border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
                  ),
                  height:40,
                  width: 60,
                  child: Icon(CupertinoIcons.back,size: 20,)),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet(){
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top:20),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30) ),
            color: AppColors.backgroundColor,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:40,left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/1.75,
                                child: Text(
                                  widget.product.productName,
                                    overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: TextStyle(
                                       
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      // fontFamily: AppFonts.textFonts,
                                      
                                      ),),
                              ),
                         
                                Text("From ${ProductContext.getOwnerName(widget.product.productOwner)}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontFamily: AppFonts.textFonts),)
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:10),
                                child: Text("Rc ${widget.product.price * count}",
                                  style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.red),),
                              ),
                              Text("⭐ ⭐ ⭐ ⭐ ⭐",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontFamily: AppFonts.textFonts),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                 getSuggestions(),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(left:20,right: 20),
                    child: Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Container(
                           width: MediaQuery.of(context).size.width/2-30,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Consumer<FavouriteListModel>(
                                 builder:(context,favourite,_)=> IconButton(
                                   icon:Icon(Entypo.heart, size: 25,
                                       color: favourite.favourite.contains(widget.product)? Colors.red:Colors.grey),
                                   onPressed: () {
                                       favourite.toggleFavourite(widget.product);
                                     },
                                 ),
                               ),
                               Consumer<CartListModel>(
                                 builder:(context,cart,_)=> IconButton(
                                   icon:Image(image: Image.asset("lib/assets/Images/order_now_logo.png").image,height: 30),
                                  //  Icon(Entypo.shopping_bag,size: 25,color: Colors.grey,), //Image(image: Image.asset("lib/assets/Images/order_now_logo.png").image,height: 30),
                                   onPressed: () async{
                                          HelperFunctions.navigate(context,CheckOut(
                                  [CartProduct(widget.product, count,widget.product.price*count).toJson()],
                                  widget.product.price*count,
                                  count
                              ));
                                      //  cart.addItem(CartProduct( widget.product, count, widget.product.price*count));
                                      //  AlertHelper.showSuccessSnackBar(context, "Added Successfully");
                                   },
                                 ),
                               ),
                           ],),
                         ),

                          Consumer<CartListModel>(
                                 builder:(context,cart,_)=>

                          GestureDetector(
                            onTap: ()async{
                              
                             if(await HelperFunctions.isSameCategory(context,cart,widget.product,count)){
                                    cart.addItem(CartProduct( widget.product, count, widget.product.price*count));
                                    AlertHelper.showSuccessSnackBar(context, "Added Successfully !");
                             }
                            },
                            child: Material(
                              elevation: 5,
                              shadowColor: AppColors.accentColor,
                              color: AppColors.accentColor,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height:40,
                                child: Center(child: Text("Add to cart",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.backgroundColor),)),
                                width: MediaQuery.of(context).size.width/2-50,
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        counterButton()
      ],
    );
  }

  Widget getSuggestions(){
    var suggestions = ProductContext.data[widget.product.productOwner][widget.product.category];
    if(suggestions.length==1){
      suggestions = ProductContext.suggestions.sublist(0,3);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20.0,top:25,bottom: 15),
          child: Row(
            children: <Widget> [
              Text("People also buy",style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List
                  .generate(
                  suggestions.length,
                      (index) {
                    var productMap = suggestions[index];
                
                    var product = productMap is Product?productMap: Product(productMap["productid"],
                        productMap["productname"],
                        int.parse(productMap["price"]),
                        ApiContext.productImageURL+ productMap["imageurl"],
                        widget.product.productOwner,
                        widget.product.category);
                    return product.productName!=widget.product.productName? suggestionTile(product):Center();
                  }
              )+[SizedBox(width: 30,)],
            ),
          ),
        )
      ],
    );

  }


  Widget suggestionTile(Product product){
    return Padding(
      padding: const EdgeInsets.only(left:20.0,bottom: 5),
      child: GestureDetector(
        onTap: (){
          HelperFunctions.navigate(context, ProductDetails(product: product));
        },
        child: Material(

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
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                      height: (MediaQuery.of(context).size.height-300)*0.5,width:(MediaQuery.of(context).size.width)*0.7,
                      imageUrl:product.imageURL,
                      fit: BoxFit.scaleDown
                      )
                // Image(image: Image.network(product.imageURL).image,fit: BoxFit.scaleDown,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget counterButton(){
    return  Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
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
                  height: 40,width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(AntDesign.minus,color: AppColors.iconColor,size: 18),
                      ),
                      Text(count.toString(),style: TextStyle(color: AppColors.textColorLight,fontWeight: FontWeight.bold,fontSize: 22),),
                      Icon(Ionicons.ios_add,color: AppColors.iconColor,)
                    ],
                  ),
                ),

                Container(
                  height: 40,width: 120,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     GestureDetector(
                       onTap:(){
                         if(count>1){
                           setState(() {
                             count--;
                           });
                         }
                       },
                       child: Container(
                          color: Colors.transparent,
                           height: 40,
                           width: 60
                       ),
                     ),
                    GestureDetector(
                      onTap:(){
                          setState(() {
                            count++;
                          });
                      },
                      child: Container(
                          color: Colors.transparent,
                          height: 40,
                          width: 60
                      ),
                    )
                  ],),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}