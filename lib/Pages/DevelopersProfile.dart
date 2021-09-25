import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperProfile extends StatefulWidget {

  @required
  var developer;

  DeveloperProfile({this.developer});

  @override
  _DeveloperProfileState createState() => _DeveloperProfileState();
}

class _DeveloperProfileState extends State<DeveloperProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
                // SizedBox(height: 10),
                getProfileImage(),
                SizedBox(height: 10),
              
                // Divider(),
                // getBigListTile(title:"Name",subtitle: widget.developer["name"],icon: Icons.person),
                // getBigListTile(title:"Academic",subtitle: widget.developer["description"],icon: Icons.library_books),
                // Divider(),
                getNormalListTile(title:"Website",icon:MaterialCommunityIcons.web,subtitle: widget.developer["website"],onClick:(){
                  launch(widget.developer["website"]);
                }),
                Padding(
                  padding: const EdgeInsets.only(left:60),
                  child: Divider(),
                ),

                ...(widget.developer['playstore']==null?[]:[
                    getNormalListTile(title:"Playstore",icon:MaterialCommunityIcons.google_play,subtitle: "https://play.google.com/store/apps/developer?id=DevAsh",onClick:(){
                      launch("https://play.google.com/store/apps/developer?id=DevAsh");
                    }),
                    Padding(
                      padding: const EdgeInsets.only(left:60),
                      child: Divider(),
                    ),
                ]),

                getNormalListTile(title:"Whatsapp",icon:MaterialCommunityIcons.whatsapp,subtitle: "+91"+widget.developer["whatsapp"],onClick:(){
                  launch("https://api.whatsapp.com/send?phone=91"+widget.developer["whatsapp"]);
                }),
                Padding(
                  padding: const EdgeInsets.only(left:60),
                  child: Divider(),
                ),
                getNormalListTile(title:"Github",icon:MaterialCommunityIcons.github_circle,subtitle: widget.developer["github"],onClick:(){
                  launch(widget.developer["github"]);
                }),
                Padding(
                  padding: const EdgeInsets.only(left:60),
                  child: Divider(),
                ),

                getNormalListTile(title:"Linkedin",icon:MaterialCommunityIcons.linkedin,subtitle: widget.developer["linkedin"],onClick:(){
                  launch(widget.developer["linkedin"]);
                }),
                Padding(
                  padding: const EdgeInsets.only(left:60),
                  child: Divider(),
                ),

                getNormalListTile(title:"Instagram",icon:MaterialCommunityIcons.instagram,subtitle: widget.developer["instagram"],onClick:(){
                  launch(widget.developer["instagram"]);
                }),
                
                SizedBox(height:50)
            ],),    
          ),
        ),
    );
  }


  getProfileImage(){
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black, 
            child: Image(image: Image.asset(widget.developer["image"]).image,height: MediaQuery.of(context).size.height/2,),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height/2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(icon: Icon(CupertinoIcons.back,color: Colors.white.withOpacity(0.9),), onPressed: Navigator.of(context).pop),
                Expanded(child: Center(),),
                Padding(
                  padding: const EdgeInsets.only(left:15.0),
                  child: Text(widget.developer["name"].trim(),style: TextStyle(color: Colors.white.withOpacity(1),fontSize: 45,),),
                ),
                Row(
                  children: [
                    Expanded(child: Center(),),
                    Padding(
                      padding: const EdgeInsets.only(left:15,bottom:8,right: 15),
                      child: Text("~ "+widget.developer["description"].trim(),style: TextStyle(color: Colors.white.withOpacity(1),fontSize: 10),),
                    ),
                  ],
                )
            ],)
        ),

      ],
    );
  }

  Widget getNormalListTile({title,subtitle,icon,onClick}){

    return  ListTile(
      onTap: onClick,
      leading: Icon(icon),
      title: Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
      subtitle: Text(subtitle),
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


}