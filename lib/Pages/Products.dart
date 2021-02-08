import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget {

  @required
  var heading;
  @required
  List products = [];

  Products({ this.heading,this.products });

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
                    HelperWidgets.getHeader(widget.heading, (){
                        Navigator.pop(context);
                    }),
                  ],
                ),
                SizedBox(height: 20,),
                
                ...List.generate(
                    widget.products.length,
                        (index) =>HelperWidgets.productListTile(
                            context, widget.products[index],showStoreName: true)
                )
              ],
            ),
          ),
        )
    );
  }
}
