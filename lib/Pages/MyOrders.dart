import 'package:RMart/Api/OrderApi.dart';
import 'package:RMart/Api/ProductsApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/OrdersListModel.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/OrderDetails.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  @override
  MyOrdersState createState() => MyOrdersState();
}

class MyOrdersState extends State<MyOrders> {
  var categories = ["Pending","Delivered","Expired","All"];
  var selectedCategory = 0;
  var isLoaded = true;

  refresh(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<OrderListModel>(
          builder:(context,orderNotifier,_)=> FutureBuilder(
          future: ProductsApi.getMyOrders(),
          builder: (context, snapshot) {

            if(!snapshot.hasData){
              return Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),),);
            }

            print("My Orders = "+snapshot.data.toString());

            var orders = snapshot.data;

            return SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HelperWidgets.getHeader(context,"", (){Navigator.pop(context);},showShoppingCart: true),
                    Padding(
                      padding: const EdgeInsets.only(left:20,top: 20),
                      child: Text("My Orders",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
                    ),
                    SizedBox(height:25),
                    HelperWidgets.getCategory(context, categories, selectedCategory, (index){
                      setState(() {
                        selectedCategory = index;

                        isLoaded = false;
                        Future.delayed(Duration(seconds: 1),(){
                          setState(() {
                            isLoaded = true;
                          });
                        });
                      });
                    }),
                    SizedBox(height:30),
                    ...getOrderList(orders,orderNotifier)
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  List<Widget> getOrderList(orders,orderNotifier){
    if(isLoaded){
      if(categories[selectedCategory]=="All"){
         return  List.generate(orders.length, (index) => orderTile(context,orders[index],orderNotifier));  
      }else if(categories[selectedCategory]=="Pending"){
        var pendingOrders =orders.where((o)=>o["status"]=="pending").toList();
        return List.generate(pendingOrders.length, (index) => orderTile(context,pendingOrders[index],orderNotifier));  
      }else if(categories[selectedCategory]=="Delivered"){
        var expOrders =orders.where((o)=>o["status"]=="delivered").toList();
        return List.generate(expOrders.length, (index) => orderTile(context,expOrders[index],orderNotifier)); 
      }else{
        var expOrders =orders.where((o)=>o["status"]=="expired").toList();
        return List.generate(expOrders.length, (index) => orderTile(context,expOrders[index],orderNotifier));  
      }

    }else{
     return [
       Padding(
        padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.25),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),),),
      )];
    }
  }

  static Widget orderTile(context,order,orderNotifier){

    var itemCount = 0;

    order["products"].forEach((e){
      itemCount+=e["count"];
    });

    return Padding(
      padding: const EdgeInsets.only(left:20,right: 20,bottom: 20),
      child: GestureDetector(
        onTap: (){
          // HelperFunctions.navigate(context,OrderDetails(order:order,orderNotifier:orderNotifier));
          Navigator.push(context, CupertinoPageRoute(builder: (ctx)=>OrderDetails(order:order,orderNotifier:orderNotifier))).then((value) {
             orderNotifier.refresh();
             }
             );

        },
        child: Material(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          elevation: 0.5,
          child: Container(
            decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(20) ,
                border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
            ),
            height: 130,
            width: MediaQuery.of(context).size.width-40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:20,left: 20,right: 20),
                      child: Text(order["orederid"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    ),
                    Expanded(child: Container()),
                    Material(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                      color: AppColors.accentColor,
                      child: Container(height: 30,width: 70,
                        child: Center(
                          child: Text("$itemCount Items",style: TextStyle(color: AppColors.backgroundColor,fontSize: 10,fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom:15),
                  child: Container(
                    width: MediaQuery.of(context).size.width-80,
                    child: Row(
                      children: [
                        Container(width: 120,
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                              Text(order["status"].toString().toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),)
                            ],
                          ),
                        ),
                        Container(height: 50,width: 0.5,color: Colors.grey,),
                        SizedBox(width: 20,),
                        Container(
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Time",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                              Text(OrderApi.getDate(order["timestamp"]),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),)
                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
