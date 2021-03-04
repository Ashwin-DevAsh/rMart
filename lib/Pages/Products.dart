import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';
import '../Extensions/StringExtensions.dart';
import 'Explore.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget {

  @required
  var heading;
  @required
  List products = [];
  Map categoricalProducts = {};

  Products({ this.heading,this.products }){
      products.forEach((element) {
          try{
            categoricalProducts[element.category].add(element);
          }catch(e){
            categoricalProducts[element.category]=[element];
          }
      });

  }

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    HelperWidgets.getHeader(context,widget.heading, (){
                        Navigator.pop(context);
                    },showShoppingCart: true),
                  ],
                ),
                SizedBox(height: 20,),
                ...getProducts(context)
              ]+(widget.products.length==0?[getEmptyWidget()]:[]),
            ),
          ),
        )
    );
  }

  List<Widget> getProducts(context){
    print(widget.categoricalProducts);
    List<Widget> widgets = [];
      widget.products.forEach((element) {
          widgets.add(HelperWidgets.productListTile(
                   context,  element,showStoreName: true));
       });

    return widgets;
  }

  Widget getEmptyWidget(){
    return  Padding(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
      child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right:20.0,top: 50,bottom: 40),
                child: Image(image: Image.asset("lib/assets/Images/coming_soon.png").image,width: MediaQuery.of(context).size.width*0.60,),
              ),
                     SizedBox(height: 10,),
              Text("Oops!",
                style: TextStyle(fontSize: 18,color: AppColors.accentColor,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("Currently we dont have any",style: TextStyle(fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,color: Colors.grey),),
              Text("items to display",style: TextStyle(fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600,color: Colors.grey))

            ],
          )
      ),
    );
  }

}
