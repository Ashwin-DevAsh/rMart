import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';

import 'Explore.dart';

class SearchResult extends StatefulWidget {

  var keyword="";
  SearchResult({this.keyword});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  var selectedCategory = 0;
  Map<String,List<Product>> allProducts = {};
  var isLoaded = true;
  var categories = [];

  @override
  void initState() {
    ProductContext.allProducts.forEach((element) {
     if(element.productName.toLowerCase().replaceAll(" ", "").contains(widget.keyword.toLowerCase().replaceAll(" ", ""))){
       try{
         allProducts[element.category].add(element);
       }catch(e){
         categories.add(element.category);
         allProducts[element.category]=[element];
       }

      }
    });
    super.initState();
  }

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
               HelperWidgets.getHeader(context,"", (){
                 Navigator.of(context).pop();
               },showShoppingCart: true),
               SizedBox(height:5),
               Padding(
                 padding: const EdgeInsets.only(left:20.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Text("Search Result",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,fontFamily: AppFonts.textFonts),),
                       Padding(
                         padding: const EdgeInsets.only(left:15.0,bottom: 15,top: 15),
                       )
                       ],
                     ),
                   ],
                 ),
               ),
               SizedBox(height:15),
               HelperWidgets.getCategory(context, categories, selectedCategory, (index){
                 setState(() {
                   selectedCategory=index;
                   isLoaded = false;
                 });
                 Future.delayed(Duration(milliseconds: 1000),(){
                   setState(() {
                     isLoaded = true;
                   });
                 });
               }),
               SizedBox(height:30),
             ]+ (categories.isEmpty?[getEmptyWidget()]: getProductWidgets()),
           ),
        ),
      ),
    );
  }


  List<Widget> getProductWidgets(){
    if(categories.length==0){
      return [Center()];
    }
    List products = allProducts[categories[selectedCategory]];
    return isLoaded?
      List.generate(
          products!=null?products.length:0,
              (index) => HelperWidgets.productListTile(context,products[index])
      ):[
      Padding(
        padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.275),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),),),
      )
    ];

  }


    Widget getEmptyWidget(){
    return  Padding(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02),
      child: Center(
          child: Column(
            children: [
              Image(image: Image.asset("lib/assets/Images/search_result.png").image,width: MediaQuery.of(context).size.width*0.60,),
              SizedBox(height: 40,),
              Text("No results found",
                style: TextStyle(fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,color: Colors.grey),),
              Text("Tap explore to find more items",
                  style: TextStyle(fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,color: Colors.grey)),
              SizedBox(height: 10,),
              Material(
                // shadowColor: AppColors.accentColor,
                // elevation: 0.1,
                // color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                  onTap: (){
                    HelperFunctions.navigate(context, Explore());

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        // borderRadius:BorderRadius.circular(5),
                        // border: Border.all(color: AppColors.accentColor.withAlpha(90),width: 0.3)
                    ),
                    height:40,
                    width: MediaQuery.of(context).size.width/2,
                    child: Center(child: Text("Explore",
                      style: TextStyle(fontSize: 18,color: AppColors.accentColor,fontWeight: FontWeight.bold),)),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

}