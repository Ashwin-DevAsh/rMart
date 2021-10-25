import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Products.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  var selectedCategory = 0;
  var imagePath = "lib/assets/Images/Categories/";
  var categories =
      ProductContext.categories.sublist(1, ProductContext.categories.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelperWidgets.getHeader(context, "", () {
                Navigator.pop(context);
              }, showShoppingCart: true),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top of",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.textFonts),
                    ),
                    Row(
                      children: [
                        Text(
                          "the day",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.textFonts),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          MaterialCommunityIcons.food_fork_drink,
                          size: 40,
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              HelperWidgets.customGridView(
                  ProductContext.allProducts.length >= 10
                      ? ProductContext.allProducts.sublist(0, 10)
                      : ProductContext.allProducts
                          .sublist(0, ProductContext.allProducts.length),
                  context,
                  extraTile: GestureDetector(
                    onTap: () {
                      var filteredProducts = [];
                      ProductContext.allProducts.forEach((element) {
                        if (!filteredProducts.contains(element)) {
                          filteredProducts.add(element);
                        }
                      });
                      HelperFunctions.navigate(
                          context,
                          Products(
                            heading: "All Products",
                            products: filteredProducts,
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Material(
                        elevation: 5,
                        shadowColor: AppColors.accentColor,
                        color: AppColors.accentColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View all",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.backgroundColor),
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 10,
                        ),
                      ),
                    ),
                  )),

              // customGridView(categories, context,extraTile: GestureDetector(
              //   onTap: (){
              //     var filteredProducts = [];
              //     ProductContext.allProducts.forEach((element) {
              //       if(!filteredProducts.contains(element)){
              //           filteredProducts.add(element);
              //       }
              //     });
              //     HelperFunctions.navigate(context, Products(heading: "All Products",products: filteredProducts,));
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom:20.0,),
              //     child: Material(
              //       shadowColor: AppColors.accentColor,
              //       elevation: 0.1,
              //       color: AppColors.backgroundColor,
              //       borderRadius:  BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              //       child: Container(
              //         decoration: BoxDecoration(
              //             color: AppColors.accentColor.withAlpha(20),
              //             borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              //             border: Border.all(color: AppColors.accentColor.withAlpha(90),width: 0.3)
              //         ),
              //         height:50,
              //         child: Center(child: Text("View all",
              //           style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.accentColor),)),
              //         width: MediaQuery.of(context).size.width/2-10,
              //       ),
              //     ),
              //   ),
              // ))
            ],
          ),
        ),
      ),
    );
  }

  Widget customGridView(List items, context, {extraTile}) {
    List<Widget> leftSide = [];
    List<Widget> rightSide = [];

    for (var i = 0; i < items.length; i++) {
      if (i % 2 == 0) {
        leftSide.add(Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: getTile(items[i]),
        ));
      } else {
        rightSide.add(Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: getTile(items[i]),
        ));
      }
    }

    if (extraTile != null && items.length > 0) {
      List<Widget> space = [extraTile];
      rightSide = space + rightSide;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: leftSide,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: rightSide,
          ),
        )
      ],
    );
  }

  Widget getTile(heading) {
    var products = ProductContext.categoricalProducts[heading];
    return GestureDetector(
      onTap: () {
        HelperFunctions.navigate(
            context,
            Products(
              heading: heading,
              products: products,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Material(
          elevation: 0.5,
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 2 - 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey.withAlpha(90), width: 0.3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      heading,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Container()),
                    Image(
                      image: Image.asset("${ApiContext.imagePath}$heading.png")
                          .image,
                      width: MediaQuery.of(context).size.width / 2 - 80,
                    ),
                    Expanded(child: Container()),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Material(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      color: AppColors.accentColor,
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(
                          child: Text(
                            "${products.length} Items",
                            style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
