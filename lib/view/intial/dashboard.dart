import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/intial/dashboard_controller.dart';
import 'package:bachelor_heaven_landlord/view/dashboard/myAds.dart';
import 'package:bachelor_heaven_landlord/view/dashboard/bookings/myBooking.dart';
import 'package:bachelor_heaven_landlord/view/dashboard/postAds.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      MyAds(),
      MyBookings(),
      PostAds(),
    ];
    return GetBuilder<DashboardController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          if(controller.tabIndex == 0){
            return alertDialog(context: context,title: 'Are you sure to exit?', onTapYes: ()=>SystemNavigator.pop(), onTapNo: ()=>Get.back());
          }  else {
            controller.changeTabIndex(0);
            return await false;
          }
        },
        child: Scaffold(
          drawer: DrawerWidget(context: context,text: _currentUser!.displayName!,
              image: _currentUser!.photoURL!),
          appBar: AppBar(
            elevation: 0,
            actions: [
              InkWell(
                onTap: ()=>Get.toNamed('/myProfile'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: lightGreyColor,
                    backgroundImage: NetworkImage(_currentUser!.photoURL!),
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100]!,
                  color: Colors.black,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'My Ads',
                    ),
                    GButton(
                      icon: Icons.book,
                      text: 'Bookings',
                    ),
                    GButton(
                      icon: Icons.post_add_outlined,
                      text: 'Post Ads',
                    ),
                  ],
                  selectedIndex: controller.tabIndex,
                  onTabChange: controller.changeTabIndex,
                ),
              ),
            ),
          ),
          body: _pages[controller.tabIndex],
        ),
      );
    });
  }
}
