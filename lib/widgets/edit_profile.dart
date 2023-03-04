import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:flutter/material.dart';

Future<dynamic> editProfileDialog({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController locationController,
  required TextEditingController phoneController,
  required VoidCallback onTap,
  // required String imgUrl,
}) async {
  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  verticalSpace,
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  verticalSpace,
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  verticalSpace,
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  verticalSpace,
                  customButton(text: 'Edit', onTap: onTap)
                ],
              ),
            )
          ],
        );
      });
}
