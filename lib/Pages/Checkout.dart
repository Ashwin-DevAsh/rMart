import 'package:RMart/Api/OrderApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Pages/CheckOutResult.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: must_be_immutable
class CheckOut extends StatefulWidget {

  List products =[] ;
  int totalAmount = 0;
  int totalItems = 0;
  CartListModel cart;


  CheckOut(this.products, this.totalAmount, this.totalItems,{this.cart});

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {


  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading?Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),),),
    ):Scaffold(
      bottomNavigationBar: bottomSheet()  ,
      backgroundColor: AppColors.backgroundColor,
      body:  SafeArea(
        child: SingleChildScrollView(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelperWidgets.getHeader(context,"Checkout", (){Navigator.pop(context);},showShoppingCart: true),
              Padding(
                padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Method",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Material(
                      color: AppColors.containerBackground,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:20,top: 12,right: 10,bottom: 12),
                              child: Image(image: Image.asset("lib/assets/Images/razorpay.png").image,),
                            ),
                            Text("Online Payment",style: TextStyle(fontWeight: FontWeight.w600),),
                            Expanded(child: Container(),),
                            Radio(groupValue: true,value: true, activeColor: AppColors.accentColor ,onChanged: (_){})
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:20),
               
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  makeOrder(context)async{

    if(isLoading){
      return;
    }
    
    setState(() {
      isLoading = true;
    });

    Map data = {
      "products":widget.products,
      "amount":widget.totalAmount.toString(),
      "orderBy":{
          "id":  "rMart@"+ UserContext.user.number,
          "name":   UserContext.user.name,
          "number": UserContext.user.number,
          "email":   UserContext.user.email
      },

    };
    var result = await OrderApi.makeOrder(data);
    print(result);
    if(result["message"]=="done"){    
         var orderID = result["orderID"]; 
         var signature = result["signature"];
         var key = result["key_id"];
         razorpayCheckout(widget.totalAmount,orderID,signature,key);
    }else{
      print(result);
      setState(() {
        isLoading = false;
      });
      if(result["message"]=="closed"){
        HelperFunctions.showAlertDialog(context,"Oops !","Sorry! Unfortunately we couldn't place this order.\n\n"+
                                  "You can place order(s) between 12:00 PM to 9:00 PM for the next day.Looking forward to your patronage. We will be improvising on our services soon!");
      }

    }
  }

  var options = {
    'name': 'rMart',
    'description': 'by team initators',
    'prefill': {
      'contact': UserContext.user.number,
      'email': UserContext.user.email
    }
  };

  razorpayCheckout(amount,orderID,signature,key){
      var razorpay = Razorpay();
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      print("\n\norder id = "+orderID);
      try{
         options["amount"] = amount*100;
         options["order_id"] = orderID;
         options["key"]=key;
        //  options["signature"] = signature;
         razorpay.open(options);
      }catch(e){
        print(e);
      }

  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
        print("\n\n success = "+response.orderId+response.paymentId);
         setState(() {
              isLoading = false;
         });
         try{
            var productMap =  widget.products[0]["product"];
            try{
              widget.cart.clear();
            }catch(e){}
            HelperFunctions.navigateReplace(context, CheckOutResult(response: response,category:productMap['category']));
         
         }catch(e){
           print(e);
           HelperFunctions.navigateReplace(context, CheckOutResult(response: response,category:null));
         }
         
  }

  void _handlePaymentError(PaymentFailureResponse response) {
          print("\n\n failed = "+response.toString());
             setState(() {
              isLoading = false;
            });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
       print("\n\n external app = "+response.toString());
          setState(() {
              isLoading = false;
            });

  }




 

  Widget bottomSheet(){
    return  Material(
      // borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
      // elevation: 10,
      color: AppColors.backgroundColor,
      child: Container(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Divider(),
            SizedBox(height: 20,),
            orderedItems(),
            SizedBox(height: 25,),

            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Items",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  Text("${widget.totalItems}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discount",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  Text("0%",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Subtotal",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(bottom:2.5,left:5),
                        child: Text("( inc. of all taxes )",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                      ),

                    ],
                  ),
                  Text("${widget.totalAmount} Rs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                ],
              ),
            ),

            Divider(),


            Padding(
              padding: const EdgeInsets.only(left:40,right: 40,bottom: 25,top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  Text("${widget.totalAmount} Rs",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:0,right: 0),
              child: GestureDetector(
                onTap: ()async{
                  makeOrder(context);

                },
                child: Material(
                    elevation: 2.5,
                    shadowColor: AppColors.accentColor,
                    // borderRadius: BorderRadius.circular(10),
                    color: AppColors.accentColor,
                    child:Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text("Pay Now - Rs ${widget.totalAmount}.00",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                    )
                ),
              ),
            ),
            // SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget orderedItems(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List
              .generate(
                 widget.products.length,
                  (index) {
                   print(widget.products);
                var productMap =  widget.products[index]["product"];
                var product = Product(
                    productMap["productID"],
                    productMap["productName"],
                    productMap["price"],
                    productMap["imageURL"],
                    productMap["productOwner"],
                    productMap["category"]);
                return productTile(CartProduct(product,
                    widget.products[index]["count"],
                    widget.products[index]["totalPrice"]));
              }
          )+[SizedBox(width: 30,)],
        ),
      ),
    );
  }

  Widget productTile(CartProduct cartProduct){
    return Padding(
      padding: const EdgeInsets.only(left:20.0,bottom: 5),
      child: Column(
        children: [
          Material(

            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            elevation: 0.5,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10) ,
                    border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
                ),
                height: 70,
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                      width: 60,
                      imageUrl:cartProduct.product.imageURL,
                      fit: BoxFit.scaleDown
                      ),
                      // Image(image: Image.network(cartProduct.product.imageURL).image,fit: BoxFit.scaleDown,width: 60,),
                      SizedBox(width: 10,),
                      Container(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                                child: Text(cartProduct.product.productName,
                                  overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                            Container(
                                width: 100,
                                child: Text("from "+ProductContext.getOwnerName(cartProduct.product.productOwner),
                                  overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: TextStyle(fontSize: 10,color: Colors.grey),)),
                            SizedBox(height: 5,),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.accentColor,
                              child: Padding(
                                padding: const EdgeInsets.only(top:2.5,bottom: 2.5,left: 10,right: 10),
                                child: Container(
                                    child: Text("x${cartProduct.count}",
                                      overflow: TextOverflow.ellipsis,maxLines: 1,
                                      style: TextStyle(fontSize: 10,color: AppColors.backgroundColor,fontWeight: FontWeight.bold),)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Text("${cartProduct.totalPrice} Rs",style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,)

                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          // Text("x${cartProduct.count}",style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }

}
