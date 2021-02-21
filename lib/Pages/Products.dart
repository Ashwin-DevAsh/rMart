import 'package:RMart/Models/Product.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import '../Extensions/StringExtensions.dart';

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
              
              ],
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
    // widget.categoricalProducts.forEach((key, value) {
      //  if(widget.heading!=key) 
      //  widgets.add(Row(
      //    children: [
      //      Padding(
      //        padding: const EdgeInsets.only(bottom:30),
      //        child: Container(
      //                 height: 50,
      //                 decoration: BoxDecoration(
      //                   border: Border(bottom: BorderSide(color: AppColors.accentColor,width: 3)),
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.only(left:20,right: 20),
      //                   child: Center(
      //                     child: Text(key.toString().capitalize(),
      //                       style: TextStyle(fontWeight: FontWeight.bold),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //      ),
      //    ],
      //  ),);
    //    value.forEach((element) {
    //       widgets.add(HelperWidgets.productListTile(
    //                context,  element,showStoreName: true));
    //    });
    // });

    return widgets;


  }
}
