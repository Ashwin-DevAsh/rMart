import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/ProductDetails.dart';
import 'package:RMart/Widgets/AlertHelper.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Merchant extends StatefulWidget {

  var merchant;

  Merchant({this.merchant});

  @override
  _MerchantState createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {

  var selectedCategory = 0;
  Map<String,List<Product>> allProducts = {};
  var isLoaded = true;
  var categories = [];

  @override
  void initState() {
    ProductContext.allProducts.forEach((element) {
     if(element.productOwner==widget.merchant){
        //  allProducts["All"] = allProducts["All"]==null?[element]:allProducts["All"]+[element];
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
                         Text(ProductContext.getOwnerName(widget.merchant),style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,fontFamily: AppFonts.textFonts),),
                       Padding(
                         padding: const EdgeInsets.only(left:15.0,bottom: 15,top: 15),
                         child: Icon(MaterialIcons.location_on),
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
