import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';

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
  var categories = ["All"];

  @override
  void initState() {
    ProductContext.allProducts.forEach((element) {
     if(element.productName.toLowerCase().replaceAll(" ", "").contains(widget.keyword.toLowerCase().replaceAll(" ", ""))){
         allProducts["All"] = allProducts["All"]==null?[element]:allProducts["All"]+[element];
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
               HelperWidgets.getHeader("", (){
                 Navigator.of(context).pop();
               }),
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
             ]+getProductWidgets(),
           ),
        ),
      ),
    );
  }


  List<Widget> getProductWidgets(){
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
}