import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Explore.dart';
import 'package:RMart/Pages/Merchant.dart';
import 'package:RMart/Pages/MyOrders.dart';
import 'package:RMart/Pages/Profile.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {

    return SafeArea(
            child:SingleChildScrollView(
              physics: BouncingScrollPhysics(),
                          child: Container(
                child: Column(
                  children: [
                    getHeader(),
                    getSearchBar(),
                    getMerchants(),
                    getSuggestion(),
                    SizedBox(height:100)

                  ],
                ),
          ),
        ),
    );
   }


   Widget getSearchBar(){

     return Padding(
       padding: const EdgeInsets.only( left: 18,right:18,top:40),
       child: Material(
         borderOnForeground: false,
         color: AppColors.containerBackground,
        
         borderRadius: BorderRadius.circular(10),
         child: Row(
           children: [
             Flexible(
                child: Container(
                 height: 55,
                 child: TextField(
                   cursorColor: AppColors.accentColor,
                   decoration: InputDecoration(
                     hintText: "what are you looking for",
                     border: OutlineInputBorder(
                      borderSide: BorderSide.none
                       )
                   ),
                 ) ,
               ),
             ),
             Material(
               elevation: 5,
               shadowColor: AppColors.accentColor,
                borderRadius: BorderRadius.circular(10),
               color: AppColors.accentColor,
               child:Container(
                 
                 height: 55,
                 width: 54,
                 child: Center(
                    child: Icon(MaterialIcons.search,color: Colors.white,),
                 ),
               )
             )
           ],
         ),
         
       ),
     );
   }

 


  Widget getSuggestion(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:22.5,top: 25),
            child: Text("Suggestions",style: TextStyle(color: AppColors.textColor,fontWeight: FontWeight.bold)),
          ),
          SizedBox(height:20),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child:HelperWidgets.customGridView(ProductContext.suggestions,context,
                extraTile: Padding(
              padding: const EdgeInsets.only(bottom:20.0),
              child: GestureDetector(
                onTap: (){
                  HelperFunctions.navigate(context, Explore());
                },
                child: Material(
                  elevation: 5,
                  shadowColor: AppColors.accentColor,
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                  child: Container(
                    height:50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Explore",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.backgroundColor),),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width/2-10,
                  ),
                ),
              ),
            ))
          )
        ],
      ),
    );
  } 





  Widget getMerchants(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left:22.5,top: 25),
            child: Text("Restaurants",style: TextStyle(color: AppColors.textColor,fontWeight: FontWeight.bold)),
          ),
          SizedBox(height:20),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(ProductContext.merchants.length,(index){
                 print("Merchant = "+ ProductContext.data[ProductContext.merchants[index]].toString());
                return merchantTile(ProductContext.getOwnerName(ProductContext.merchants[index],),
                    ProductContext.data[ProductContext.merchants[index]],ProductContext.merchants[index]);
              })+[SizedBox(width:20)],
            ),
          )
        ],
      ),
    );
  }

  Widget merchantTile(String title,Map object,String merchantID){
       return Padding(
                  padding: const EdgeInsets.only(left:20.0,bottom: 10),
                  child: GestureDetector(
                    onTap: (){
                      HelperFunctions.navigate(context, Merchant(merchant:merchantID));
                    },
                    child: Material(
                      elevation: 0.5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 130,
                        width: 160,
                        child: Padding(
                          padding: const EdgeInsets.only(left:15.0,top:15,bottom: 10,right:10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Entypo.shop),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                        width: 100,
                                        child: Text(title,style: TextStyle(),overflow: TextOverflow.ellipsis,)
                                    ),
                                    Icon(MaterialIcons.arrow_forward,size: 20,)
                              ],)

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
  }


   Widget getHeader(){
     return Padding(
       padding: const EdgeInsets.only(left:20,top: 20,right: 20),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  GestureDetector(
                     onTap: (){
                       HelperFunctions.navigate(context, MyOrders());
                      //  openBottomSheet();
                     },
                      child:Icon(MaterialCommunityIcons.hamburger)
                  ),
                  SizedBox(height:15),
                  Text("Let's eat",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,fontFamily: AppFonts.textFonts),),
                  SizedBox(height:2.5),
                  Text("Quality foods",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,fontFamily: AppFonts.textFonts)),

               ],
             ),
             GestureDetector(
               onTap: (){
                 HelperFunctions.navigate(context, Profile());
               },
               child: Material(
                 borderRadius: BorderRadius.circular(25),
                 child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      child: Center(
                        child:CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: ApiContext.imageURL+UserContext.user.rmartId+".jpg",
                          placeholder: (context, url) => Image.asset("lib/assets/Images/avatar.webp"),
                          errorWidget: (context, url, error) => Image.asset("lib/assets/Images/avatar.webp"),
                        )
                      ),
                    color: Colors.white,
                     width: 50,
                     height: 50,

                   ),
                 ),
               ),
             )
           ],
         ),
       
     );

   }

  //  openBottomSheet(){
  //    showModalBottomSheet(
  //        isDismissible: false,
  //        elevation: 10,
  //        barrierColor: Colors.transparent,
  //        context: context,
  //        builder: (context){
  //          return Container(
  //            color: AppColors.backgroundColor,
  //            child: Column(
  //              crossAxisAlignment: CrossAxisAlignment.start,
  //              children: [
  //                Padding(
  //                  padding: const EdgeInsets.only(top:20,left: 20,bottom: 20),
  //                  child: Column(
  //                    crossAxisAlignment: CrossAxisAlignment.start,
  //                    children: [
  //                      // Text("Pending",style: TextStyle(fontSize: 35,fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w500),),
  //                      // Text("Orders",style: TextStyle(fontSize: 25,fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w500),),

  //                    ],
  //                  ),
  //                ),
  //               MyOrdersState.orderTile(context)

  //              ],),
  //          );
  //        });
  //  }

}