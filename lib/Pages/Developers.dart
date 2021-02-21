import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Developers extends StatefulWidget {
  @override
  _DevelopersState createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {

  var mentors = [
        {
          'name':'Kumar',
          'description':'Alumini officer'
        }
  ];

  var developers = [
        {
          'name':'Ashwin',
          'description':'CSE A 2018 - 2022',
          'image':'lib/assets/Images/Developers/ashwin.png',
          'website':'https://www.devash.tech'
        },
        {
          'name':'Bharat version',
          'description':'CSE A 2018 - 2022',
          'image':'lib/assets/Images/Developers/bv.png',
          'website':'https://www.bharatversion.me'

        },
        {
          'name':'Barath raj kumaran',
          'description':'CSE A 2018 - 2022',
          'image':'lib/assets/Images/Developers/vbrk.png',
          'website':'https://www.vbrk.me'

        }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Builder(
          builder: (context) {
            return SafeArea(
               child: SingleChildScrollView(
                 child: Column(
                   children: [

                     HelperWidgets.getHeader(context, "", Navigator.of(context).pop),
                     SizedBox(height: 10),
                     getGreetings(),
                    //  getTitle("Mentor"),
                    //  ...List.generate(mentors.length, (index){

                    //    return getProfile(mentors[index]['name'], mentors[index]['description'], "imagePath");

                    //  })  ,
                     getTitle("Developers"),
                     ...List.generate(developers.length, (index){

                       return getProfile(developers[index]['name'], developers[index]['description'],developers[index]['image'],developers[index]['website']);

                     })

                   ],
                 ),
               ),
            );
            
            },
            )
      
    );
  }

  Widget getTitle(text){

    return   Row(
                           children: [
                             Padding(
             padding: const EdgeInsets.only(bottom:30,top: 30),
             child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.accentColor,width: 3)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:20,right: 20),
                        child: Center(
                              child: Text(text,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                        ),
                      ),
                    ),
           ),
                           ],
                         );
  }


   Widget getGreetings(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                  "team",
                  style: TextStyle(fontSize: 32, ),
                ),
                SizedBox(height: 10),
                    Text(
                  "Initiators",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ],
        ),
      ),
    );
  }


  Widget getProfile(title,subtitle,imagePath,website){
    return Padding(
      padding: const EdgeInsets.only(left:20,right: 20,top: 10,bottom: 15),
      child: GestureDetector(
        onTap: (){
          launch(website);
        },
              child: Material(
           color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          elevation: 0.25,
                child: Container(
                      decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(10) ,
                border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
            ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:12.5,bottom: 12.5,left:12.5,right: 10),
                    child: Row(
            children: [
              Container(
                                decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(30) ,
                border: Border.all(color: Colors.grey.withAlpha(90),width: 0.3)
            ),
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image(
                        
                        fit: BoxFit.cover,
                        image:  Image.asset(imagePath).image,
                      ),
                    ) ,
              ),
              SizedBox(width: 20,),
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                      SizedBox(height: 5,),
                      Text(subtitle,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),)
                    ],
              )
            ],
          ),
                  ),
                ),
        ),
      ),
    );
  }
}