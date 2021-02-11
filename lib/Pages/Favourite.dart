import 'dart:async';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/Explore.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Favourite extends StatefulWidget {

  var callBack;

  Favourite({this.callBack});

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {

  var selectedCategory = 0;
  List<Widget> products;
  bool isLoaded = true;




  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  children: [
                    HelperWidgets.getHeader(context,"Favourites",widget.callBack),
                    HelperWidgets.getCategory(context,ProductContext.categories,selectedCategory,(index){
                      setState(() {
                        selectedCategory = index;
                        isLoaded = false;
                      });
                      Future.delayed(Duration(milliseconds: 1000),(){
                        setState(() {
                          isLoaded = true;
                        });
                      });
                    }),
                    SizedBox(height: 30,),
                    !isLoaded? Padding(
                      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.3),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),),),
                    )
                        :Consumer<FavouriteListModel>(
                      builder:(context,favouriteList,_){
                        products = [];
                        Future<bool> getWidgets() async {
                          for(var i in ProductContext.categories){
                            List<Product> items = [];
                            for(var product in favouriteList.favourite){
                              if(i=="All"){
                                items.add(product);
                              }else if(product.category==i) {
                                items.add(product);
                              }
                            }

                            if(items.isEmpty){
                              products.add(
                                  getEmptyWidget()
                              );
                            }else{
                              products.add(HelperWidgets.customGridView(
                                items ,context,extraTile:   Padding(
                              padding: const EdgeInsets.only(bottom:20.0,),
                              child: GestureDetector(
                                onTap: (){
                                   HelperFunctions.navigate(context, Explore());
                                },
                                                              child: Material(
                                  shadowColor: AppColors.accentColor,
                                  elevation: 0.1,
                                  color: AppColors.backgroundColor,
                                  borderRadius:    BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.accentColor.withAlpha(20),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                        border: Border.all(color: AppColors.accentColor.withAlpha(90),width: 0.3)
                                    ),
                                    height:50,
                                    child: Center(child: Text("Add More",
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.accentColor),)),
                                    width: MediaQuery.of(context).size.width/2-10,
                                  ),
                                ),
                              ),
                            )
                            ));
                            }
                          }


                          return true;
                        }

                        getWidgets();
                        return IndexedStack(
                          index: selectedCategory,
                          children: products,
                        );
                      },
                    ),
                    SizedBox(height: 100,)
                  ],
            ),),
          ),

        ],
    )
      );
  }



  Widget getEmptyWidget(){
    return  Padding(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.05),
      child: Center(
          child: Column(
            children: [
              Image(image: Image.asset("lib/assets/Images/foods.png").image,width: MediaQuery.of(context).size.width*0.75,),
              SizedBox(height: 10,),
              Text("Your list is empty",
                style: TextStyle(fontSize: 12,color: Colors.grey),),
              Text("Add something from the menu",
                  style: TextStyle(fontSize: 12,color: Colors.grey)),
              SizedBox(height: 30,),
              Material(
                shadowColor: AppColors.accentColor,
                elevation: 0.1,
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                  onTap: (){
                    HelperFunctions.navigate(context, Explore());

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.accentColor.withAlpha(20),
                        borderRadius:BorderRadius.circular(5),
                        border: Border.all(color: AppColors.accentColor.withAlpha(90),width: 0.3)
                    ),
                    height:40,
                    width: MediaQuery.of(context).size.width/2,
                    child: Center(child: Text("Explore",
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.accentColor),)),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  
}