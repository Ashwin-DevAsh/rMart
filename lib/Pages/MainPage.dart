import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Favourite.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'Cart/Cart.dart';
import 'Home.dart';

class MainPage extends StatefulWidget {
  var shouldShowDisclimer;

  MainPage({this.shouldShowDisclimer = false});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    if (widget.shouldShowDisclimer) {
      // Future.delayed(Duration(seconds: 2), () {
      //   HelperFunctions.showAlertDialog(
      //       context,
      //       "Disclaimer",
      //       "The product images shown are for illustration purposes only and may not be an exact representation of the product.\n\n" +
      //           "Orders which are not collected within a day will expire automatically.\n\n" +
      //           "No refund will be issued if the customer fails to collect the product before the token expires.\n\n" +
      //           "Orders cannot be cancelled once the order is placed and token is generated.\n\n" +
      //           "Exchange of product with different item is not applicable.\n\n");
      // });
    }

    super.initState();
  }

  var pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  Future<bool> back() {
    if (pageIndex != 0) {
      setState(() {
        pageIndex = 0;
        final CurvedNavigationBarState navBarState =
            _bottomNavigationKey.currentState;
        navBarState.setPage(0);
      });
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar:Material(child: getBottomNavigationBar()),
        backgroundColor: AppColors.backgroundColor,

        body: Stack(
          children: [
            IndexedStack(
              children: [
                Home(),
                Cart(
                  callBack: back,
                ),
                Favourite(
                  callBack: back,
                )
              ],
              index: pageIndex,
            ),
            Column(
              children: [
                Expanded(child: Container()),
                getBottomNavigationBar()
              ],
            )
          ],
        ),
      ),
    );
  }

  CurvedNavigationBar getBottomNavigationBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      buttonBackgroundColor: AppColors.accentColor,
      height: 65,
      color: AppColors.accentColor,
      backgroundColor: Colors.white.withAlpha(10),
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Padding(
          padding: const EdgeInsets.all(2.5),
          child: Icon(Entypo.shopping_cart, size: 25, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.all(2.5),
          child: Icon(AntDesign.heart, size: 25, color: Colors.white),
        ),
      ],
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }
}
