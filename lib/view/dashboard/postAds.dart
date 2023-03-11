import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/post/post_controller.dart';
import 'package:bachelor_heaven_landlord/controller/post/post_stepper_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/post%20add/stepList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostAds extends StatelessWidget {
  PostAds({Key? key}) : super(key: key);

  TextEditingController titleController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  PostController _postController = Get.find();

  User? _currentUser = FirebaseAuth.instance.currentUser;

  String _currentTime =
      DateFormat.yMMMMd('en_US').add_jms().format(DateTime.now());

  // List<Location>? locations;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StepperController>(builder: (controller) {
      return Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: bgColor),
        ),
        child: Scaffold(
          body: SafeArea(
              child: Obx(
            () => Stepper(
              currentStep: controller.currentStep,
              type: StepperType.vertical,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Expanded(child: customButton(text: 'Next', onTap: details.onStepContinue!)),
                      horizontalSpace,
                      Expanded(child: customButton(text: 'Back', onTap: details.onStepCancel!)),
                    ],
                  ),
                );
              },
              steps: stepList(
                  locationTitle: 'Hi',
                  titleController: titleController,
                  addressController: addressController,
                  priceController: priceController,
                  descriptionController: descriptionController,
                  context: context),
              onStepContinue: () async {
                if (controller.currentStep == 0) {
                  if (titleController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Enter a title', toastLength: Toast.LENGTH_SHORT);
                  } else if (priceController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Enter the price',
                        toastLength: Toast.LENGTH_SHORT);
                  } else if (addressController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Enter your location',
                        toastLength: Toast.LENGTH_SHORT);
                  } else {
                    await controller.getLatLon(
                        '${addressController.text}, ${_postController.division}');
                    controller.stepIncrement();
                  }
                } else if (controller.currentStep == 1) {
                  if (descriptionController.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'Enter the description');
                  } else {
                    controller.stepIncrement();
                  }
                } else {
                  if (_postController.myFile.path == null) {
                    Fluttertoast.showToast(msg: 'Add a photo');
                  } else {
                    QuerySnapshot userData = await FirebaseFirestore.instance
                        .collection('landlords')
                        .where('uid', isEqualTo: _currentUser!.uid)
                        .get();
                    _postController.addPost(
                        context: context,
                        latitude: '${controller.locations.last.latitude}',
                        longitude: '${controller.locations.last.longitude}',
                        currentUserUid: _currentUser!.uid,
                        adOwnerUid: _currentUser!.uid,
                        adOwnerPhone: '${userData.docs.single['phoneNumber']}',
                        time: _currentTime,
                        title: titleController.text.trim(),
                        category: _postController.category,
                        description: descriptionController.text.trim(),
                        address: addressController.text.trim(),
                        division: _postController.division,
                        price: priceController.text.trim());
                  }
                }
              },
              onStepCancel: () {
                if (controller.currentStep == 0) {
                  print('Completed');
                } else {
                  controller.stepDecrement();
                }
              },
            ),
          )),
        ),
      );
    });
  }
}
