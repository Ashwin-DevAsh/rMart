import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/User.dart';
import 'package:RMart/Pages/MyOrders.dart';
import 'package:RMart/Pages/Registration/Otp.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sembast/sembast.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
           physics: BouncingScrollPhysics(),
           child: Column(
             children: [
               HelperWidgets.getHeader(context,"", (){Navigator.pop(context);}),

               getProfile(),
               SizedBox(height: 20,),
               Divider(),
               SizedBox(height: 10,),

               Column(
                 children: [

                   getBigListTile(
                       title: "Name",
                       subtitle: UserContext.user.name,
                       icon:Icons.person_outline
                   ),

                   getBigListTile(
                       title: "Number",
                       subtitle: "+91"+UserContext.user.number,
                       icon:Icons.call_outlined
                   ),

                   getBigListTile(
                       title: "Email",
                       subtitle: UserContext.user.email,
                       icon:Icons.mail_outline
                   ),

                   Divider(),

                   getNormalListTile(
                       title: "My Orders",
                       icon:MaterialCommunityIcons.history,
                       onClick: (){
                         HelperFunctions.navigate(context, MyOrders());
                       }),
            

                   Divider(),
                  getNormalListTile(
                       title: "Password Recovery",
                       icon:MaterialCommunityIcons.lock_outline,
                       onClick: (){
                         HelperFunctions.navigate(context, Otp(isRecoveryOtp: true,number: UserContext.user.number,email: UserContext.user.email,));
                       }),
            

                  //  Divider(),

                   getNormalListTile(
                       title: "Logout",
                       icon: Feather.log_out,
                       onClick: ()async{
                         await StoreRef.main().record("User").delete(DataBaseHelper.db);
                         Future.delayed(Duration(seconds: 1),(){
                           SystemNavigator.pop(animated: true);
                         });
                       }
                   ),

                   Divider(),

                    getNormalListTile(
                       title: "Support",
                       icon: FontAwesome.support,
                       onClick: ()async{
                         launch("mailto:rpay.support@rajalakshmi.edu.in?subject=rMart Support");
                       }
                   ),

                 ],
               )
             ],
           ),
        ),
      ),
    );
  }

  Widget getNormalListTile({title,icon,onClick}){

    return  ListTile(
      onTap: onClick,
      leading: Icon(icon),
      title: Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
      trailing: Icon(CupertinoIcons.forward),
    );

  }

  Widget getBigListTile({title,subtitle,icon}){
    return  ListTile(
      onTap: (){},
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
        ],
      ),
      title: Text(title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
      subtitle: Text(subtitle),
    );
  }

  Widget getProfile(){
    return Padding(
      padding: const EdgeInsets.only(left:20,right: 20,top: 10),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: ApiContext.profileURL+"rMart@"+UserContext.user.number+".jpg",
                placeholder: (context, url) => Image.asset("lib/assets/Images/avatar.webp"),
                errorWidget: (context, url, error) => Image.asset("lib/assets/Images/avatar.webp"),
              ),
            ) ,
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(UserContext.user.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              SizedBox(height: 5,),
              Text("rMart@"+UserContext.user.number,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),)
            ],
          )
        ],
      ),
    );

  }

}

