import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/auth/auth_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget DrawerWidget({required String image, required String text, required BuildContext context}) {
  AuthController _contrtoller = Get.find();
  return Drawer(

    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: bgColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 35,
                  backgroundColor: lightGreyColor,
                  backgroundImage: NetworkImage(image)),
              verticalSpace,
              Text(
                text,
                style: poppinsTextStyle(
                    color: whiteColor, size: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () =>_contrtoller.signOut(context),
          title: Text('Sign Out'.toUpperCase()),
          subtitle: Text('See ya!'),
          leading: Icon(Icons.logout),
        ),
      ],
    ),
  );
}